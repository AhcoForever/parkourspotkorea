import 'package:drift/drift.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../database/app_database.dart';

/// 로컬 사용자 데이터 Repository
class UserRepository {
  static final UserRepository _instance = UserRepository._internal();

  factory UserRepository() => _instance;

  UserRepository._internal();

  final AppDatabase _database = AppDatabase();

  /// 🔍 사용자 조회
  Future<LocalUser?> getUser(String uid) async {
    return await _database.getUser(uid);
  }

  /// ✍️ 사용자 생성
  Future<void> createUser({
    required String uid,
    required String email,
    double? latitude,
    double? longitude,
  }) async {
    // 위치 정보가 없으면 기본값 사용 (서울시청)
    final lat = latitude ?? 37.5665;
    final lng = longitude ?? 126.9780;

    final companion = UsersCompanion(
      uid: Value(uid),
      email: Value(email),
      currentLatitude: Value(lat),
      currentLongitude: Value(lng),
      createdAt: Value(DateTime.now()),
    );

    await _database.insertOrUpdateUser(companion);
    print('✅ 로컬 사용자 생성: $email');
  }

  /// 🔄 사용자 존재 여부 확인 및 생성
  Future<void> ensureUserExists({
    required String uid,
    required String email,
  }) async {
    final existingUser = await getUser(uid);

    if (existingUser == null) {
      // 사용자가 없으면 생성
      await createUser(uid: uid, email: email);
    } else {
      // 있으면 동기화 시간만 업데이트
      await updateSyncTime(uid);
    }
  }

  /// 📍 현재 위치 업데이트
  Future<void> updateLocation(
    String uid,
    double latitude,
    double longitude,
  ) async {
    await _database.updateCurrentLocation(uid, latitude, longitude);
  }

  /// 🎯 새로운 지역 방문
  Future<void> visitRegion(String uid, String regionId) async {
    await _database.visitNewRegion(uid, regionId);
  }

  /// 📊 탐험 통계 조회
  Future<Map<String, dynamic>> getExplorationStats(String uid) async {
    return await _database.getExplorationStats(uid);
  }

  /// 🗺️ 방문한 지역 목록 조회
  Future<List<String>> getVisitedRegions(String uid) async {
    return await _database.getVisitedRegions(uid);
  }

  /// 🧭 사용자 위치 기반 초기 카메라 위치 반환
  Future<LatLng> getInitialCameraPosition() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      print('❌ 로그인된 사용자가 없습니다.');
      return const LatLng(37.5665, 126.9780); // fallback: 서울
    }

    final localUser = await getUser(firebaseUser.uid);
    if (localUser == null) {
      print('❌ 로컬 사용자 정보가 없습니다.');
      return const LatLng(37.5665, 126.9780); // fallback
    }

    return LatLng(localUser.currentLatitude, localUser.currentLongitude);
  }
  // 현재 로그인된 Firebase 사용자 ID 반환
  Future<String> getUserId() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      throw Exception('❌ 로그인된 사용자가 없습니다.');
    }
    return firebaseUser.uid;
  }

  /// 🔄 동기화 시간 업데이트
  Future<void> updateSyncTime(String uid) async {
    await _database.updateSyncTime(uid);
  }

  /// 🗑️ 사용자 삭제
  Future<void> deleteUser(String uid) async {
    await _database.deleteUser(uid);
  }

  /// 📍 현재 위치 가져오기 (유틸리티)
  Future<Position?> getCurrentPosition() async {
    try {
      // 위치 권한 확인
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        return null;
      }

      // 현재 위치 가져오기
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (e) {
      print('❌ 위치 가져오기 실패: $e');
      return null;
    }
  }

  /// 🔒 데이터베이스 닫기
  void dispose() {
    _database.close();
  }
}
