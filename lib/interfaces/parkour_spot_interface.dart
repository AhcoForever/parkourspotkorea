
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../model/parkour_spot.dart';

/// 파쿠르 장소 검색 필터
class ParkourSpotFilter {
  final String? searchQuery;
  final List<String>? categories;
  final List<String>? difficulties;
  final double? minRating;
  final LatLng? center;
  final double? radiusKm;
  final bool? verifiedOnly;

  const ParkourSpotFilter({
    this.searchQuery,
    this.categories,
    this.difficulties,
    this.minRating,
    this.center,
    this.radiusKm,
    this.verifiedOnly,
  });
}

/// 파쿠르 장소 Repository 인터페이스
abstract class IParkourSpotRepository {
  // 캐싱 관련
  Future<List<ParkourSpot>> getCachedSpots({ParkourSpotFilter? filter});
  Future<void> syncSpotsFromFirestore({int? sido, bool forceSync = false});
  Future<void> clearSpotsCache({int? sido});

  // 검색 관련
  Future<List<ParkourSpot>> searchSpots(String query, {LatLng? userLocation});
  Future<List<ParkourSpot>> getSpotsByLocation(LatLng center, double radiusKm);
  Future<List<ParkourSpot>> getSpotsByCategory(String category);

  // 마커 변환
  Set<Marker> convertSpotsToMarkers(List<ParkourSpot> spots, {Function(ParkourSpot)? onTap});

  // 개별 장소 관리
  Future<ParkourSpot?> getSpotById(String id);
  Future<void> updateSpotRating(String id, double rating);


}

/// 파쿠르 장소 서비스 인터페이스 (Firestore 연동)
abstract class IParkourSpotService {
  Future<List<Map<String, dynamic>>> fetchSpotsBySido(int sido);
  Future<List<Map<String, dynamic>>> fetchSpotsInBounds(LatLng southwest, LatLng northeast);
  Future<Map<String, dynamic>?> fetchSpotById(String id);
  Future<List<Map<String, dynamic>>> searchSpotsRemote(String query, {int limit = 20});
}