import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../database/app_database.dart';

/// 지도 데이터 Repository 인터페이스
abstract class IScratchMapRepository {
  Future<List<PolygonRow>> getPolygonsBySido(int sido);
  Future<Set<Polygon>> fetchAndCachePolygons(int sido);
  Future<void> clearPolygonsCache(int sido);
  Set<Polygon> convertRowsToPolygons(List<PolygonRow> rows); // 추가
}

/// 위치 서비스 인터페이스
abstract class ILocationService {
  Future<Position?> getCurrentPosition();
  Future<int> resolveSidoCode(LatLng latLng);
  Future<bool> checkLocationPermission();
}

/// 사용자 데이터 Repository 인터페이스
abstract class IUserRepository {
  Future<LatLng> getInitialCameraPosition();
  Future<List<String>> getVisitedRegions(String uid);
  Future<void> visitRegion(String uid, String regionId);
  Future<String?> getCurrentUserId();
}

/// 헥사곤 서비스 인터페이스
abstract class IHexagonService {
  HexagonData? createHexagon(LatLng origin, LatLng currentPosition);
  HexagonData? restoreHexagon(LatLng origin, String hexId);
  String generateHexId(LatLng origin, LatLng position);
}

/// 헥사곤 데이터 모델
class HexagonData {
  final String id;
  final LatLng center;
  final List<LatLng> points;

  const HexagonData({
    required this.id,
    required this.center,
    required this.points,
  });
}