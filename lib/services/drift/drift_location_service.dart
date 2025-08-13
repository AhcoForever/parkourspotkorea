import 'dart:async';
import 'package:geolocator/geolocator.dart';

import '../../core/app_db.dart';
import 'drift_user_service.dart';

/// 위치 추적 및 Scratch Map 업데이트 서비스
class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  final DriftUserService _userSvc = DriftUserService(AppDB.instance);
  StreamSubscription<Position>? _positionStream;

  // 위치 업데이트 설정
  static const locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100, // 100m 이동 시 업데이트
  );

  /// 📍 위치 추적 시작
  Future<void> startLocationTracking(String uid) async {
    // 권한 확인
    final permission = await _checkLocationPermission();
    if (!permission) return;

    // 이전 스트림 취소
    await _positionStream?.cancel();

    // 새 위치 추적 시작
    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) async {
      await _handleLocationUpdate(uid, position);
    });

    print('📍 위치 추적 시작됨');
  }

  /// 🛑 위치 추적 중지
  Future<void> stopLocationTracking() async {
    await _positionStream?.cancel();
    _positionStream = null;
    print('🛑 위치 추적 중지됨');
  }

  /// 📍 단일 위치 업데이트
  Future<void> updateCurrentLocation(String uid) async {
    final permission = await _checkLocationPermission();
    if (!permission) return;

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      await _handleLocationUpdate(uid, position);

    } catch (e) {
      print('❌ 위치 업데이트 오류: $e');
    }
  }

  /// 🗺️ 현재 위치가 어느 지역인지 확인
  Future<String?> getCurrentRegionId(double lat, double lng) async {
    // TODO: 실제 구현 시 GeoJSON 데이터와 비교하여 지역 ID 반환
    // 현재는 예시로 간단한 로직만 구현

    // 서울 지역 예시 (실제로는 정확한 polygon 검사 필요)
    if (lat >= 37.4 && lat <= 37.7 && lng >= 126.8 && lng <= 127.2) {
      return '11010'; // 서울특별시 종로구
    }

    return null;
  }

  /// 📊 사용자의 탐험 통계 조회
  Future<Map<String, dynamic>> getExplorationStats(String uid) async {
    return await _userSvc.getExplorationStats(uid);
  }

  /// 🗺️ 방문한 지역 목록 조회
  Future<List<String>> getVisitedRegions(String uid) async {
    return await _userSvc.getVisitedRegions(uid);
  }

  /// 🔄 위치 업데이트 처리
  Future<void> _handleLocationUpdate(String uid, Position position) async {
    // 1. 현재 위치 업데이트
    await _userSvc.updateCurrentLocation(
      uid,
      position.latitude,
      position.longitude,
    );

    // 2. 현재 위치가 속한 지역 확인
    final regionId = await getCurrentRegionId(
      position.latitude,
      position.longitude,
    );

    // 3. 새로운 지역이면 방문 기록에 추가
    if (regionId != null) {
      await _userSvc.visitNewRegion(uid, regionId);
    }

    print('📍 위치 업데이트: (${position.latitude}, ${position.longitude})');
  }

  /// 🔐 위치 권한 확인
  Future<bool> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('❌ 위치 서비스가 비활성화되어 있습니다.');
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('❌ 위치 권한이 거부되었습니다.');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('❌ 위치 권한이 영구적으로 거부되었습니다.');
      return false;
    }

    return true;
  }

  /// 🗑️ 서비스 정리
  void dispose() {
    _positionStream?.cancel();
  }
}