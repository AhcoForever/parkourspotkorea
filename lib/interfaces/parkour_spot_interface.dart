import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../model/parkour_spot.dart';

/// 파쿠르 스팟 도메인 전용 레포지토리
abstract class IParkourSpotRepository {
  /// 중심 좌표 기준 반경 내 스팟 조회 (MVP: Firestore lat/lng + 클라 하버사인)
  Future<List<ParkourSpot>> fetchNearby({
    required LatLng center,
    double radiusKm = 5.0,
    int limit = 200,
  });

  /// 실시간 필요 시 (선택)
  Stream<List<ParkourSpot>> watchNearby({
    required LatLng center,
    double radiusKm = 5.0,
    int limit = 200,
  });

  /// 단건/변경 (확장 용도)
  Future<ParkourSpot?> getById(String id);
  Future<void> upsert(ParkourSpot spot);
  Future<void> delete(String id);
}