import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:parkourspotkorea/database/user_table.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../model/user.dart';

part 'app_database.g.dart'; // 코드 생성 파일

@DriftDatabase(tables: [Users])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /// 사용자 관련 모든 CRUD 작업

  // 🔍 사용자 조회
  Future<LocalUser?> getUser(String uid) async {
    return await (select(users)..where((tbl) => tbl.uid.equals(uid))).getSingleOrNull();
  }

  Future<List<LocalUser>> getAllUsers() async {
    return await select(users).get();
  }

  // ✍️ 사용자 추가/업데이트
  Future<void> insertOrUpdateUser(UsersCompanion user) async {
    await into(users).insertOnConflictUpdate(user);
    print('✅ 사용자 저장 완료');
  }

  // 📍 위치 업데이트
  Future<void> updateUserLocation(String uid, double newLat, double newLng) async {
    final user = await getUser(uid);
    if (user == null) return;

    // 위치 및 업데이트 시간 갱신
    await (update(users)..where((tbl) => tbl.uid.equals(uid))).write(
      UsersCompanion(
        latitude: Value(newLat),
        longitude: Value(newLng),
        lastLocationUpdate: Value(DateTime.now()),
      ),
    );

    print('📍 위치 업데이트: ($newLat, $newLng)');
  }

  // 🎯 방문 지역 추가
  Future<void> addVisitedRegion(String uid, String regionId) async {
    final user = await getUser(uid);
    if (user == null) return;

    // 현재 방문 지역 파싱
    List<String> currentVisited = _parseStringList(user.visitedRegions);

    // 이미 방문했다면 무시
    if (currentVisited.contains(regionId)) return;

    // 새 지역 추가
    currentVisited.add(regionId);
    int newCount = currentVisited.length;

    await (update(users)..where((tbl) => tbl.uid.equals(uid))).write(
      UsersCompanion(
        visitedRegions: Value(currentVisited.join(',')),
        totalVisitedCount: Value(newCount),
      ),
    );

    print('🎯 새 지역 방문: $regionId (총 ${newCount}개)');
  }

  // 📊 탐험 통계 조회
  Future<Map<String, dynamic>?> getExplorationStats(String uid) async {
    final user = await getUser(uid);
    if (user == null) return null;

    return {
      'uid': user.uid,
      'displayName': user.displayName,
      'totalVisitedCount': user.totalVisitedCount,
      'visitedRegions': _parseStringList(user.visitedRegions),
      'lastLocationUpdate': user.lastLocationUpdate,
    };
  }

  // 🗑️ 사용자 삭제
  Future<void> deleteUser(String uid) async {
    await (delete(users)..where((tbl) => tbl.uid.equals(uid))).go();
  }

  // 🔄 방문 기록 초기화
  Future<void> clearVisitedRegions(String uid) async {
    await (update(users)..where((tbl) => tbl.uid.equals(uid))).write(
      const UsersCompanion(
        visitedRegions: Value(''),
        totalVisitedCount: Value(0),
      ),
    );
    print('🔄 방문 기록 초기화 완료');
  }

  // 🏆 상위 탐험가들 조회
  Future<List<LocalUser>> getTopExplorers({int limit = 10}) async {
    return await (select(users)
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.totalVisitedCount)])
      ..limit(limit))
        .get();
  }

  // 📍 특정 지역 방문 여부 확인
  Future<bool> hasVisitedRegion(String uid, String regionId) async {
    final user = await getUser(uid);
    if (user == null) return false;

    List<String> visited = _parseStringList(user.visitedRegions);
    return visited.contains(regionId);
  }

  // ⚙️ 헬퍼 메서드들

  /// String을 List<String>으로 파싱
  List<String> _parseStringList(String? value) {
    if (value == null || value.isEmpty) return [];
    return value.split(',').where((s) => s.isNotEmpty).toList();
  }

  /// UserStatus enum 처리
  UserStatus _parseUserStatus(String status) {
    switch (status) {
      case 'active': return UserStatus.active;
      case 'inactive': return UserStatus.inactive;
      case 'banned': return UserStatus.banned;
      default: return UserStatus.inactive;
    }
  }
}

// 데이터베이스 연결 설정
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'parkour_app.db'));
    return NativeDatabase.createInBackground(file);
  });
}
