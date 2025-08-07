import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:parkourspotkorea/database/user_table.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

@DriftDatabase(tables: [Users])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2; // 스키마 버전 증가 (마이그레이션용)

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // 기존 테이블에서 새 테이블로 마이그레이션
      if (from < 2) {
        // 기존 데이터가 있다면 필요한 필드만 보존
        await m.createAll();
      }
    },
  );

  /// 🔍 사용자 조회
  Future<LocalUser?> getUser(String uid) async {
    return await (select(users)..where((tbl) => tbl.uid.equals(uid))).getSingleOrNull();
  }

  /// ✍️ 사용자 생성 또는 업데이트
  Future<void> insertOrUpdateUser(UsersCompanion user) async {
    await into(users).insertOnConflictUpdate(user);
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

  /// 🎯 새로운 지역 방문 처리
  Future<void> visitNewRegion(String uid, String regionId) async {
    final user = await getUser(uid);
    if (user == null) return;

    // 이미 방문한 지역인지 확인
    final visitedList = _parseVisitedRegions(user.visitedRegions);
    if (visitedList.contains(regionId)) return;

    // 새 지역 추가
    visitedList.add(regionId);
    final newCount = visitedList.length;

    // 전체 지역 수 (추후 constants에서 가져올 예정)
    const totalRegions = 3500; // 대한민국 전체 읍면동 개수 (예시)
    final progress = (newCount / totalRegions) * 100;

    await (update(users)..where((tbl) => tbl.uid.equals(uid))).write(
      UsersCompanion(
        visitedRegions: Value(visitedList.join(',')),
        totalVisitedCount: Value(newCount),
        explorationProgress: Value(progress),
      ),
    );

    print('🎯 새 지역 방문: $regionId (총 ${newCount}개, ${progress.toStringAsFixed(1)}% 완료)');
  }

  /// 📊 방문한 지역 목록 조회
  Future<List<String>> getVisitedRegions(String uid) async {
    final user = await getUser(uid);
    if (user == null) return [];
    return _parseVisitedRegions(user.visitedRegions);
  }

  /// 🔄 Firebase와 동기화 시간 업데이트
  Future<void> updateSyncTime(String uid) async {
    await (update(users)..where((tbl) => tbl.uid.equals(uid))).write(
      UsersCompanion(lastSyncAt: Value(DateTime.now())),
    );
  }

  /// 🏆 탐험 통계 조회
  Future<Map<String, dynamic>> getExplorationStats(String uid) async {
    final user = await getUser(uid);
    if (user == null) return {};

    return {
      'totalVisited': user.totalVisitedCount,
      'progress': user.explorationProgress,
      'lastUpdate': user.lastLocationUpdate,
      'visitedRegions': _parseVisitedRegions(user.visitedRegions),
    };
  }

  /// 🗑️ 사용자 삭제
  Future<void> deleteUser(String uid) async {
    await (delete(users)..where((tbl) => tbl.uid.equals(uid))).go();
  }

  /// 유틸리티: 방문 지역 문자열 파싱
  List<String> _parseVisitedRegions(String regions) {
    if (regions.isEmpty) return [];
    return regions.split(',').where((s) => s.isNotEmpty).toList();
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