// lib/database/app_database.dart

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:parkourspotkorea/database/user_table.dart';
import 'package:parkourspotkorea/database/parkour_table.dart'; // 새로 추가
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// 파쿠르 테이블들을 추가해야 합니다
@DriftDatabase(tables: [Users, Polygons, ParkourSpots, ParkourSpotIndices])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4; // 스키마 버전 증가 (파쿠르 테이블 추가)

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
}

// 데이터베이스 연결 설정
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'scratch_map.db'));
    return NativeDatabase.createInBackground(file);
  });
}