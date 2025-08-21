// lib/interfaces/parkour_interfaces.dart


import '../model/parkour_spot.dart';

/// 파쿠르 스팟 데이터 소스 인터페이스
abstract class ParkourDataSource {
  Future<List<ParkourSpot>> getAllParkourSpots();
  Future<List<ParkourSpot>> getParkourSpotsByRegion(String regionCode);
  Future<List<ParkourSpot>> getParkourSpotsByLocation({
    required double latitude,
    required double longitude,
    required double radiusKm,
  });
  Future<ParkourSpot?> getParkourSpot(String id);
  Future<List<ParkourSpot>> getParkourSpotsUpdatedAfter(DateTime lastSync);
}

/// 파쿠르 스팟 캐시 인터페이스
abstract class ParkourCacheInterface {
  Future<void> cacheParkourSpots(List<ParkourSpot> spots);
  Future<List<ParkourSpot>> getCachedParkourSpots();
  Future<List<ParkourSpot>> getCachedParkourSpotsByCategory(String category);
  Future<List<ParkourSpot>> getCachedParkourSpotsByLocation({
    required double latitude,
    required double longitude,
    required double radiusKm,
  });
  Future<List<ParkourSpot>> searchCachedParkourSpots(String query);
  Future<ParkourSpot?> getCachedParkourSpot(String id);
  Future<void> clearCache();
  Future<DateTime?> getLastSyncTime();
  Future<void> updateLastSyncTime();
  Future<bool> hasCachedData();
  Future<int> getCachedCount();
}

/// 파쿠르 스팟 리포지토리 인터페이스
abstract class ParkourRepository {
  Future<List<ParkourSpot>> getAllParkourSpots({bool forceRefresh = false});
  Future<List<ParkourSpot>> getParkourSpotsByLocation({
    required double latitude,
    required double longitude,
    required double radiusKm,
    bool forceRefresh = false,
  });
  Future<List<ParkourSpot>> searchParkourSpots(String query);
  Future<ParkourSpot?> getParkourSpot(String id);
  Future<void> syncParkourSpots();
  Future<bool> isDataStale();
}

/// 검색 결과 타입
class ParkourSearchResult {
  final List<ParkourSpot> spots;
  final String query;
  final int totalCount;
  final bool isFromCache;

  const ParkourSearchResult({
    required this.spots,
    required this.query,
    required this.totalCount,
    required this.isFromCache,
  });
}

/// 위치 기반 쿼리 매개변수
class LocationQuery {
  final double latitude;
  final double longitude;
  final double radiusKm;

  const LocationQuery({
    required this.latitude,
    required this.longitude,
    required this.radiusKm,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationQuery &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.radiusKm == radiusKm;
  }

  @override
  int get hashCode => Object.hash(latitude, longitude, radiusKm);
}

/// 파쿠르 스팟 필터
class ParkourSpotFilter {
  final List<String>? categories;
  final List<String>? difficulties;
  final double? minRating;
  final bool? isVerified;
  final bool? isIndoor;

  const ParkourSpotFilter({
    this.categories,
    this.difficulties,
    this.minRating,
    this.isVerified,
    this.isIndoor,
  });

  bool matches(ParkourSpot spot) {
    if (categories != null && !categories!.contains(spot.category)) {
      return false;
    }
    if (difficulties != null && !difficulties!.contains(spot.difficulty)) {
      return false;
    }
    return true;
  }
}

/// 예외 클래스들
class ParkourException implements Exception {
  final String message;
  final dynamic originalError;

  const ParkourException(this.message, [this.originalError]);

  @override
  String toString() => 'ParkourException: $message';
}

class ParkourCacheException extends ParkourException {
  const ParkourCacheException(String message, [dynamic originalError])
      : super(message, originalError);
}

class ParkourNetworkException extends ParkourException {
  const ParkourNetworkException(String message, [dynamic originalError])
      : super(message, originalError);
}