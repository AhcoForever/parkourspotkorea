import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

import '../interfaces/scratch_map_interfaces.dart';
import '../model/hexagon_data.dart';
import '../repositories/user_repository.dart';
import '../const/constants.dart';
import '../utils/hex_helper.dart';

/// 위치 및 헥사곤 관련 Repository 구현체
/// Service 로직을 Repository 내부로 통합하여 ViewModel에서는 Repository만 사용
class LocationRepository implements ILocationRepository {
  final UserRepository _userRepository;

  LocationRepository({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  // === 위치 관련 기능 ===

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

  @override
  Stream<Position> getPositionStream() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 80, // 헥사곤 크기의 80%
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  /// 지역명으로 sido 코드 변환
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

  // === 헥사곤 관련 기능 ===

  @override
  Future<String> generateHexId(LatLng position) async {
    return hexIdFromLatLng(AppConstants.GLOBAL_HEX_ORIGIN, position, AppConstants.GLOBAL_HEX_SIZE_METERS);
  }

  @override
  Future<HexagonData?> createHexagon(LatLng position) async {
    try {
      // 스냅된 중심점 계산
      final snappedCenter = snapToHexCenter(
          AppConstants.GLOBAL_HEX_ORIGIN,
          position,
          AppConstants.GLOBAL_HEX_SIZE_METERS
      );

      // 헥사곤 ID 생성
      final hexId = hexIdFromLatLng(
          AppConstants.GLOBAL_HEX_ORIGIN,
          position,
          AppConstants.GLOBAL_HEX_SIZE_METERS
      );

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
  Future<Set<Polygon>> restoreVisitedHexagons(List<String> hexIds) async {
    final hexagons = <Polygon>{};

    for (final hexId in hexIds) {
      final hexagonData = await _restoreHexagon(hexId);
      if (hexagonData != null) {
        hexagons.add(Polygon(
          polygonId: PolygonId(hexId),
          points: hexagonData.points,
          strokeColor: Colors.green,
          fillColor: const Color(0x4432CD32),
          strokeWidth: 2,
        ));
      }
    }

    return hexagons;
  }

  @override
  Future<Polygon?> createHexagonAtPosition(LatLng position, String uid) async {
    try {
      // 1. 헥사곤 데이터 생성
      final hexagonData = await createHexagon(position);
      if (hexagonData == null) return null;

      // 2. 방문 여부 확인
      final visitedRegions = await _userRepository.getVisitedRegions(uid);
      final isVisited = visitedRegions.contains(hexagonData.id);

      // 3. 폴리곤 생성
      final polygon = Polygon(
        polygonId: PolygonId(hexagonData.id),
        points: hexagonData.points,
        strokeColor: isVisited ? Colors.green : const Color(0xFFFF5722),
        fillColor: isVisited ? const Color(0x4432CD32) : const Color(0x44FF5722),
        strokeWidth: 2,
      );

      // 4. 방문 기록 저장 (새로운 방문인 경우)
      if (!isVisited) {
        await _userRepository.visitRegion(uid, hexagonData.id);
        print("🟢 새로운 방문 이력 저장됨: ${hexagonData.id}");
      }

      return polygon;
    } catch (e) {
      print('❌ 헥사곤 생성 실패: $e');
      return null;
    }
  }

  /// 저장된 헥사곤 복원 (private 메소드)
  Future<HexagonData?> _restoreHexagon(String hexId) async {
    try {
      LatLng? center;

      if (hexId.startsWith('h_')) {
        // 새 포맷: h_q_r
        final parts = hexId.split('_');
        if (parts.length == 3) {
          final q = int.tryParse(parts[1]);
          final r = int.tryParse(parts[2]);
          if (q != null && r != null) {
            center = hexCenterFromIndex(
                AppConstants.GLOBAL_HEX_ORIGIN,
                q,
                r,
                AppConstants.GLOBAL_HEX_SIZE_METERS
            );
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
}