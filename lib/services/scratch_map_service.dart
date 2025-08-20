import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../interfaces/scratch_map_interfaces.dart';
import '../model/hexagon_data.dart';
import '../repositories/user_repository.dart';
import '../utils/hex_helper.dart';
import '../const/constants.dart';

/// 위치 서비스 구현체
class ScratchMapService implements ILocationService {
  @override
  Future<Position?> getCurrentPosition() async {
    try {
      // 위치 권한 확인
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        print('❌ 위치 권한이 거부되었습니다.');
        return null;
      }

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

  @override
  Future<int> resolveSidoCode(LatLng latLng) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      if (placemarks.isEmpty) {
        print('⚠️ 주소 정보를 찾을 수 없습니다. 서울로 기본 설정');
        return 11;
      }

      final name = placemarks.first.administrativeArea ?? '';
      final sidoCode = _getSidoCodeFromName(name);

      print('📍 위치: $name -> sido: $sidoCode');
      return sidoCode;
    } catch (e) {
      print('❌ sido 코드 변환 실패: $e');
      return 11;
    }
  }

  @override
  Future<bool> checkLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  int _getSidoCodeFromName(String name) {
    const sidoMap = {
      '서울특별시': 11,
      '부산광역시': 26,
      '대구광역시': 27,
      '인천광역시': 28,
      '광주광역시': 29,
      '대전광역시': 30,
      '울산광역시': 31,
      '세종특별자치시': 36,
      '경기도': 41,
      '강원특별자치도': 42,
      '충청북도': 43,
      '충청남도': 44,
      '전라북도': 45,
      '전라남도': 46,
      '경상북도': 47,
      '경상남도': 48,
      '제주특별자치도': 50,
    };

    final normalized = name.replaceAll('강원도', '강원특별자치도');
    return sidoMap[normalized] ?? 11;
  }
}

/// 사용자 Repository 구현체 (기존 UserRepository 래핑)
class ScratchMapUserRepository implements IUserRepository {
  final UserRepository userRepository;

  ScratchMapUserRepository({required this.userRepository});

  @override
  Future<LatLng> getInitialCameraPosition() async {
    return await userRepository.getInitialCameraPosition();
  }

  @override
  Future<List<String>> getVisitedRegions(String uid) async {
    return await userRepository.getVisitedRegions(uid);
  }

  @override
  Future<void> visitRegion(String uid, String regionId) async {
    await userRepository.visitRegion(uid, regionId);
  }

  @override
  Future<String?> getCurrentUserId() async {
    return FirebaseAuth.instance.currentUser?.uid;
  }
}

/// 헥사곤 서비스 구현체
class HexagonService implements IHexagonService {
  @override
  HexagonData? createHexagon(LatLng origin, LatLng currentPosition) {
    try {
      // 스냅된 중심점 계산
      final snappedCenter = snapToHexCenter(origin, currentPosition, AppConstants.GLOBAL_HEX_SIZE_METERS);

      // 헥사곤 ID 생성
      final hexId = hexIdFromLatLng(origin, currentPosition, AppConstants.GLOBAL_HEX_SIZE_METERS);

      // 헥사곤 좌표 생성
      final hexPoints = generateHexagon(snappedCenter, AppConstants.GLOBAL_HEX_SIZE_METERS);

      return HexagonData(
        id: hexId,
        center: snappedCenter,
        points: hexPoints,
      );
    } catch (e) {
      print('❌ 헥사곤 생성 실패: $e');
      return null;
    }
  }

  @override
  HexagonData? restoreHexagon(LatLng origin, String hexId) {
    try {
      LatLng? center;

      if (hexId.startsWith('h_')) {
        // 새 포맷: h_q_r
        final parts = hexId.split('_');
        if (parts.length == 3) {
          final q = int.tryParse(parts[1]);
          final r = int.tryParse(parts[2]);
          if (q != null && r != null) {
            center = hexCenterFromIndex(origin, q, r, AppConstants.GLOBAL_HEX_SIZE_METERS);
          }
        }
      } else if (hexId.startsWith('hex_')) {
        // 옛 포맷: hex_lat_lng
        final coords = hexId.replaceFirst('hex_', '').split('_');
        if (coords.length == 2) {
          final lat = double.tryParse(coords[0]);
          final lng = double.tryParse(coords[1]);
          if (lat != null && lng != null) {
            center = LatLng(lat, lng);
          }
        }
      }

      if (center == null) return null;

      final hexPoints = generateHexagon(center, AppConstants.GLOBAL_HEX_SIZE_METERS);

      return HexagonData(
        id: hexId,
        center: center,
        points: hexPoints,
      );
    } catch (e) {
      print('❌ 헥사곤 복원 실패: $e');
      return null;
    }
  }

  @override
  String generateHexId(LatLng origin, LatLng position) {
    return hexIdFromLatLng(origin, position, AppConstants.GLOBAL_HEX_SIZE_METERS);
  }
}