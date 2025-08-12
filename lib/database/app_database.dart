import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:parkourspotkorea/database/user_table.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

@DriftDatabase(tables: [Users, Polygons])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3; // 스키마 버전 증가 (마이그레이션용)

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();

      //인덱스 생성
      await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_polygons_sido ON polygons(sido);'
      );
      await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_polygons_sgg_prefix ON polygons(sgg_prefix);'
      );
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // 기존 테이블에서 새 테이블로 마이그레이션
      if (from < 2) {
        // 기존 데이터가 있다면 필요한 필드만 보존
        await m.createAll();
      }
    },
  );


  //todo: jh app_database 그대로 놔두고, business logic 포함된 method는 services/drift/drift_map_service.dart로 이동. , /services/drift/drift_user_service.dart 로 분리
  /// 🔍 사용자 조회
  Future<LocalUser?> getUser(String uid) async {
    return await (select(
      users,
    )..where((tbl) => tbl.uid.equals(uid))).getSingleOrNull();
  }

  /// ✍️ 사용자 생성 또는 업데이트
  Future<void> insertOrUpdateUser(UsersCompanion user) async {
    await into(users).insertOnConflictUpdate(user);
  }

  /// ===== Polygons (로컬 캐시) =====
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

  /// 📍 현재 위치 업데이트
  Future<void> updateCurrentLocation(String uid, double lat, double lng) async {
    await (update(users)..where((tbl) => tbl.uid.equals(uid))).write(
      UsersCompanion(
        currentLatitude: Value(lat),
        currentLongitude: Value(lng),
        lastLocationUpdate: Value(DateTime.now()),
      ),
    );
  }




  /// 🔄 Firebase와 동기화 시간 업데이트
  Future<void> updateSyncTime(String uid) async {
    await (update(users)..where((tbl) => tbl.uid.equals(uid))).write(
      UsersCompanion(lastSyncAt: Value(DateTime.now())),
    );
  }


  /// 🗑️ 사용자 삭제
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
