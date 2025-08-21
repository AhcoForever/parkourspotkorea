import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../database/app_database.dart';
import '../model/hexagon_data.dart';

/// 지도 데이터 Repository 인터페이스
abstract class IScratchMapRepository {
  Future<List<PolygonRow>> getPolygonsBySido(int sido);
  Future<Set<Polygon>> fetchAndCachePolygons(int sido);
  Future<void> clearPolygonsCache(int sido);
  Set<Polygon> convertRowsToPolygons(List<PolygonRow> rows); // 추가
}

// 위치 및 헥사곤 Repository 인터페이스
abstract class ILocationRepository {
  Future<Position?> getCurrentPosition();
  Future<int> resolveSidoCode(LatLng latLng);
  Future<bool> checkLocationPermission();
  Stream<Position> getPositionStream();

  Future<String> generateHexId(LatLng position);
  Future<HexagonData?> createHexagon(LatLng position);
  Future<Set<Polygon>> restoreVisitedHexagons(List<String> hexIds);
  Future<Polygon?> createHexagonAtPosition(LatLng position, String uid);
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
/// 위치 서비스 인터페이스
abstract class ILocationService {
  Future<Position?> getCurrentPosition();
  Future<int> resolveSidoCode(LatLng latLng);
  Future<bool> checkLocationPermission();
}

