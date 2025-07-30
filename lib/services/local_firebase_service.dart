import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:path_provider/path_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

/// Firebase 관련 서비스
class FirebaseService {
  static final FirebaseService instance = FirebaseService._init();

  late final FirebaseStorage _storage;
  late final FirebaseRemoteConfig _remoteConfig;
  final Dio _dio = Dio();

  FirebaseService._init();

  /// Firebase 서비스 초기화
  Future<void> initialize() async {
    _storage = FirebaseStorage.instance;
    _remoteConfig = FirebaseRemoteConfig.instance;

    // Remote Config 초기화
    await _initRemoteConfig();
  }

  /// Remote Config 초기화
  Future<void> _initRemoteConfig() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1), // 1시간마다 업데이트 체크
    ));

    // 기본값 설정
    await _remoteConfig.setDefaults({
      'geojson_version': '1.0.0',
      'geojson_path': 'assets/GeoJSON/HangJeongDong_ver20250401.geojson',
      'enable_caching': true,
      'cache_duration_days': 30,
    });

    // 설정 가져오기
    await _remoteConfig.fetchAndActivate();
  }

  /// GeoJSON 파일 경로 가져오기
  String get geoJsonPath => _remoteConfig.getString('geojson_path');
  String get geoJsonVersion => _remoteConfig.getString('geojson_version');
  bool get enableCaching => _remoteConfig.getBool('enable_caching');
  int get cacheDurationDays => _remoteConfig.getInt('cache_duration_days');

  /// 네트워크 연결 상태 확인
  Future<bool> isNetworkAvailable() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  /// GeoJSON 데이터 로드 (캐시 우선)
  Future<Map<String, dynamic>> loadKoreaGeoJson() async {
    try {
      // 1. 캐시 확인
      final cachedData = await _loadCachedGeoJson();
      if (cachedData != null) {
        print('캐시된 GeoJSON 사용');
        return cachedData;
      }

      // 2. 네트워크 확인
      final isOnline = await isNetworkAvailable();
      if (!isOnline) {
        throw Exception('네트워크 연결이 필요합니다.');
      }

      // 3. Firebase Storage에서 다운로드
      print('Firebase Storage에서 GeoJSON 다운로드 시작...');
      final data = await _downloadGeoJsonFromFirebase();

      // 4. 캐시 저장
      if (enableCaching) {
        await _saveCacheGeoJson(data);
      }

      return data;

    } catch (e) {
      print('GeoJSON 로드 실패: $e');

      // 오프라인 폴백: 이전 캐시 사용 (만료되었더라도)
      final oldCache = await _loadCachedGeoJson(ignoreExpiry: true);
      if (oldCache != null) {
        print('만료된 캐시 사용 (오프라인 모드)');
        return oldCache;
      }

      throw e;
    }
  }

  /// Firebase Storage에서 GeoJSON 다운로드
  Future<Map<String, dynamic>> _downloadGeoJsonFromFirebase() async {
    try {
      // Storage 참조
      final ref = _storage.ref(geoJsonPath);

      // 다운로드 URL 가져오기
      final downloadUrl = await ref.getDownloadURL();

      // 메타데이터 확인 (파일 크기 등)
      final metadata = await ref.getMetadata();
      print('GeoJSON 파일 크기: ${(metadata.size! / 1024 / 1024).toStringAsFixed(2)} MB');

      // 다운로드 (진행률 표시)
      final response = await _dio.get(
        downloadUrl,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = (received / total * 100).toStringAsFixed(0);
            print('다운로드 진행률: $progress%');
          }
        },
        options: Options(
          responseType: ResponseType.json,
          receiveTimeout: Duration(minutes: 5),
        ),
      );

      return response.data as Map<String, dynamic>;

    } catch (e) {
      print('Firebase Storage 다운로드 실패: $e');
      throw e;
    }
  }

  /// 캐시된 GeoJSON 로드
  Future<Map<String, dynamic>?> _loadCachedGeoJson({bool ignoreExpiry = false}) async {
    try {
      final cacheDir = await getApplicationDocumentsDirectory();
      final cacheFile = File('${cacheDir.path}/korea_geojson_cache.json');
      final metaFile = File('${cacheDir.path}/korea_geojson_meta.json');

      if (!cacheFile.existsSync() || !metaFile.existsSync()) {
        return null;
      }

      // 메타데이터 확인
      final metaData = json.decode(await metaFile.readAsString());
      final cachedVersion = metaData['version'] as String;
      final cacheTime = DateTime.parse(metaData['timestamp'] as String);

      // 버전 확인
      if (cachedVersion != geoJsonVersion) {
        print('캐시 버전 불일치: $cachedVersion != $geoJsonVersion');
        return null;
      }

      // 만료 확인
      if (!ignoreExpiry) {
        final expiryDate = cacheTime.add(Duration(days: cacheDurationDays));
        if (DateTime.now().isAfter(expiryDate)) {
          print('캐시 만료됨');
          return null;
        }
      }

      // 캐시 데이터 로드
      final jsonString = await cacheFile.readAsString();
      return json.decode(jsonString) as Map<String, dynamic>;

    } catch (e) {
      print('캐시 로드 실패: $e');
      return null;
    }
  }

  /// GeoJSON 캐시 저장
  Future<void> _saveCacheGeoJson(Map<String, dynamic> data) async {
    try {
      final cacheDir = await getApplicationDocumentsDirectory();
      final cacheFile = File('${cacheDir.path}/korea_geojson_cache.json');
      final metaFile = File('${cacheDir.path}/korea_geojson_meta.json');

      // 메타데이터 저장
      final metaData = {
        'version': geoJsonVersion,
        'timestamp': DateTime.now().toIso8601String(),
      };
      await metaFile.writeAsString(json.encode(metaData));

      // 데이터 저장
      await cacheFile.writeAsString(json.encode(data));

      print('GeoJSON 캐시 저장 완료');

    } catch (e) {
      print('캐시 저장 실패: $e');
    }
  }

  /// 캐시 삭제
  Future<void> clearGeoJsonCache() async {
    try {
      final cacheDir = await getApplicationDocumentsDirectory();
      final cacheFile = File('${cacheDir.path}/korea_geojson_cache.json');
      final metaFile = File('${cacheDir.path}/korea_geojson_meta.json');

      if (cacheFile.existsSync()) await cacheFile.delete();
      if (metaFile.existsSync()) await metaFile.delete();

      print('캐시 삭제 완료');
    } catch (e) {
      print('캐시 삭제 실패: $e');
    }
  }

  /// 업데이트 확인
  Future<bool> checkForUpdates() async {
    try {
      await _remoteConfig.fetchAndActivate();

      // 현재 캐시된 버전과 비교
      final cachedData = await _loadCachedGeoJson(ignoreExpiry: true);
      if (cachedData == null) return true; // 캐시가 없으면 업데이트 필요

      final cacheDir = await getApplicationDocumentsDirectory();
      final metaFile = File('${cacheDir.path}/korea_geojson_meta.json');

      if (metaFile.existsSync()) {
        final metaData = json.decode(await metaFile.readAsString());
        final cachedVersion = metaData['version'] as String;

        return cachedVersion != geoJsonVersion;
      }

      return true;
    } catch (e) {
      print('업데이트 확인 실패: $e');
      return false;
    }
  }

  /// 사용자 데이터 백업 (Firestore 사용)
  Future<void> backupUserData(String userId, Map<String, dynamic> data) async {
    // TODO: Firestore 연동 시 구현
    // FirebaseFirestore.instance
    //   .collection('users')
    //   .doc(userId)
    //   .set(data);
  }
}