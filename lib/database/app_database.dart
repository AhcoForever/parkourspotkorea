// lib/database/app_database.dart

import 'dart:io';
import 'dart:math' as math;
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:parkourspotkorea/database/user_table.dart';
import 'package:parkourspotkorea/database/parkour_table.dart'; // 새로 추가
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

@DriftDatabase(tables: [Users, Polygons, ParkourSpots, ParkourSpotIndices])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 5; // 스키마 버전 증가 (파쿠르 테이블 추가)

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();

      // 기존 인덱스 생성
      await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_polygons_sido ON polygons(sido);'
      );
      await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_polygons_sgg_prefix ON polygons(sgg_prefix);'
      );

      // 파쿠르 관련 인덱스 생성
      await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_parkour_spots_location ON parkour_spots(latitude, longitude);'
      );
      await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_parkour_spots_category ON parkour_spots(category);'
      );
      await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_parkour_spots_rating ON parkour_spots(rating);'
      );
      await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_parkour_search_term ON parkour_spot_indices(search_term);'
      );
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        // 기존 데이터가 있다면 필요한 필드만 보존
        await m.createAll();
      }

      // 파쿠르 테이블 추가 (버전 4)
      if (from < 4) {
        await m.createTable(parkourSpots);
        await m.createTable(parkourSpotIndices);

        // 파쿠르 관련 인덱스 생성
        await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_parkour_spots_location ON parkour_spots(latitude, longitude);'
        );
        await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_parkour_spots_category ON parkour_spots(category);'
        );
        await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_parkour_spots_rating ON parkour_spots(rating);'
        );
        await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_parkour_search_term ON parkour_spot_indices(search_term);'
        );
      }
    },
  );

  // 기존 메소드들 유지
  Future<LocalUser?> getUser(String uid) async {
    return await (select(users)..where((tbl) => tbl.uid.equals(uid))).getSingleOrNull();
  }

  Future<void> insertOrUpdateUser(UsersCompanion user) async {
    await into(users).insertOnConflictUpdate(user);
  }

  Future<List<PolygonRow>> getPolygonsBySido(int sido) {
    return (select(polygons)..where((t) => t.sido.equals(sido))).get();
  }

  Future<List<PolygonRow>> getPolygonsBySggPrefix(int sggPrefix) {
    return (select(polygons)..where((t) => t.sggPrefix.equals(sggPrefix))).get();
  }

  Future<void> upsertPolygonsCompanions(List<PolygonsCompanion> items) async {
    if (items.isEmpty) return;
    await batch((b) {
      b.insertAllOnConflictUpdate(polygons, items);
    });
  }

  Future<void> updateCurrentLocation(String uid, double lat, double lng) async {
    await (update(users)..where((tbl) => tbl.uid.equals(uid))).write(
      UsersCompanion(
        currentLatitude: Value(lat),
        currentLongitude: Value(lng),
        lastLocationUpdate: Value(DateTime.now()),
      ),
    );
  }

  Future<void> updateSyncTime(String uid) async {
    await (update(users)..where((tbl) => tbl.uid.equals(uid))).write(
      UsersCompanion(lastSyncAt: Value(DateTime.now())),
    );
  }

  Future<void> deleteUser(String uid) async {
    await (delete(users)..where((tbl) => tbl.uid.equals(uid))).go();
  }

  // 파쿠르 스팟 검색 메소드들
  Future<List<ParkourSpotEntity>> searchParkourSpots({
    String? query,
    String? category,
    double? minRating,
    String? difficulty,
    double? userLat,
    double? userLng,
    double? maxDistanceKm,
    int limit = 50,
  }) async {
    final selectQuery = select(parkourSpots);
    
    if (query != null && query.isNotEmpty) {
      final searchTerms = query.toLowerCase().split(' ');
      selectQuery.where((spot) {
        Expression<bool>? condition;
        for (final term in searchTerms) {
          final termCondition = spot.name.lower().contains(term) |
              spot.description.lower().contains(term) |
              spot.address.lower().contains(term);
          condition = condition == null ? termCondition : (condition & termCondition);
        }
        return condition ?? const Constant(true);
      });
    }
    
    if (category != null && category.isNotEmpty) {
      selectQuery.where((spot) => spot.category.equals(category));
    }
    
    if (minRating != null) {
      selectQuery.where((spot) => spot.rating.isBiggerOrEqualValue(minRating));
    }
    
    if (difficulty != null && difficulty.isNotEmpty) {
      selectQuery.where((spot) => spot.difficulty.equals(difficulty));
    }
    
    selectQuery.limit(limit);
    final spots = await selectQuery.get();
    
    // 거리 필터링이 필요한 경우
    if (userLat != null && userLng != null && maxDistanceKm != null) {
      return spots.where((spot) {
        final distance = _calculateDistance(
          userLat, userLng, 
          spot.latitude, spot.longitude
        );
        return distance <= maxDistanceKm;
      }).toList()..sort((a, b) {
        final distA = _calculateDistance(userLat, userLng, a.latitude, a.longitude);
        final distB = _calculateDistance(userLat, userLng, b.latitude, b.longitude);
        return distA.compareTo(distB);
      });
    }
    
    return spots;
  }

  Future<List<ParkourSpotEntity>> getNearbyParkourSpots(
    double userLat, 
    double userLng, 
    {double radiusKm = 5.0, int limit = 20}
  ) async {
    final spots = await select(parkourSpots).get();
    
    final nearbySpots = spots.where((spot) {
      final distance = _calculateDistance(
        userLat, userLng, 
        spot.latitude, spot.longitude
      );
      return distance <= radiusKm;
    }).toList();
    
    nearbySpots.sort((a, b) {
      final distA = _calculateDistance(userLat, userLng, a.latitude, a.longitude);
      final distB = _calculateDistance(userLat, userLng, b.latitude, b.longitude);
      return distA.compareTo(distB);
    });
    
    return nearbySpots.take(limit).toList();
  }

  Future<List<String>> getPopularSearchTerms() async {
    final query = '''
      SELECT search_term, COUNT(*) as count 
      FROM parkour_spot_indices 
      WHERE term_type = 0 
      GROUP BY search_term 
      ORDER BY count DESC 
      LIMIT 10
    ''';
    
    final result = await customSelect(query).get();
    return result.map((row) => row.data['search_term'] as String).toList();
  }

  Future<void> insertParkourSpot(ParkourSpotsCompanion spot) async {
    await into(parkourSpots).insertOnConflictUpdate(spot);
  }

  Future<void> updateParkourSpotSearchIndices(String spotId, List<String> terms) async {
    // 기존 인덱스 삭제
    await (delete(parkourSpotIndices)..where((tbl) => tbl.spotId.equals(spotId))).go();
    
    // 새 인덱스 추가
    final indices = <ParkourSpotIndicesCompanion>[];
    for (final term in terms) {
      indices.add(ParkourSpotIndicesCompanion(
        spotId: Value(spotId),
        searchTerm: Value(term.toLowerCase()),
        termType: const Value(0), // 0: 일반 검색어
      ));
    }
    
    if (indices.isNotEmpty) {
      await batch((b) {
        b.insertAll(parkourSpotIndices, indices);
      });
    }
  }

  double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const double earthRadius = 6371; // km
    final double dLat = _toRadians(lat2 - lat1);
    final double dLng = _toRadians(lng2 - lng1);
    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) * math.cos(_toRadians(lat2)) *
        math.sin(dLng / 2) * math.sin(dLng / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * math.pi / 180;
  }
}

// 데이터베이스 연결 설정
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'scratch_map.db'));
    return NativeDatabase.createInBackground(file);
  });
}