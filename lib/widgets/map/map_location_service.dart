// lib/widgets/map/map_location_service.dart
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// 위치 관련 서비스
///
/// GPS 권한 요청, 현재 위치 조회 등을 담당
/// 다른 프로젝트에서도 재사용 가능
class MapLocationService {
  /// 위치 권한 확인 및 요청
  ///
  /// Returns:
  /// - true: 권한 허용됨
  /// - false: 권한 거부됨
  static Future<bool> checkAndRequestPermission() async {
    // 위치 서비스 활성화 확인
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // 위치 서비스가 비활성화되어 있음
      return false;
    }

    // 권한 확인
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // 권한 요청
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // 권한 거부됨
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // 권한이 영구적으로 거부됨 (설정에서 변경 필요)
      return false;
    }

    // 권한 허용됨
    return true;
  }

  /// 현재 위치 가져오기
  ///
  /// Returns:
  /// - LatLng: 현재 위치
  /// - null: 위치를 가져올 수 없음 (권한 거부, GPS 비활성화 등)
  static Future<LatLng?> getCurrentLocation() async {
    try {
      // 권한 확인 및 요청
      bool hasPermission = await checkAndRequestPermission();
      if (!hasPermission) {
        print('위치 권한이 거부되었습니다');
        return null;
      }

      // 현재 위치 가져오기
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      print('위치 가져오기 실패: $e');
      return null;
    }
  }

  /// 현재 위치 가져오기 (타임아웃 설정)
  ///
  /// [timeoutSeconds]: 타임아웃 시간 (초), 기본값 5초
  /// [fallbackPosition]: 타임아웃 시 반환할 기본 위치
  static Future<LatLng?> getCurrentLocationWithTimeout({
    int timeoutSeconds = 5,
    LatLng? fallbackPosition,
  }) async {
    try {
      final location = await getCurrentLocation().timeout(
        Duration(seconds: timeoutSeconds),
        onTimeout: () {
          print('위치 가져오기 타임아웃');
          return fallbackPosition;
        },
      );
      return location;
    } catch (e) {
      print('위치 가져오기 실패: $e');
      return fallbackPosition;
    }
  }

  /// 두 위치 사이의 거리 계산 (미터)
  ///
  /// [start]: 시작 위치
  /// [end]: 끝 위치
  /// Returns: 두 위치 사이의 거리 (미터)
  static double calculateDistance(LatLng start, LatLng end) {
    return Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }

  /// 두 위치 사이의 거리 계산 (킬로미터)
  static double calculateDistanceInKm(LatLng start, LatLng end) {
    return calculateDistance(start, end) / 1000;
  }

  /// 실시간 위치 추적 스트림
  ///
  /// [distanceFilter]: 위치 업데이트 최소 거리 (미터), 기본값 10m
  static Stream<LatLng> getLocationStream({int distanceFilter = 10}) {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings)
        .map((position) => LatLng(position.latitude, position.longitude));
  }

  /// 위치 서비스 활성화 여부 확인
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// 현재 권한 상태 확인
  static Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// 앱 설정 열기 (권한이 영구 거부된 경우)
  static Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }

  /// 위치 설정 열기 (GPS가 비활성화된 경우)
  static Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }
}
