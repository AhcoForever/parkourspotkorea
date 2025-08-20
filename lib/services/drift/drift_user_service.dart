import 'package:drift/drift.dart';
import '../../database/app_database.dart';

/// 사용자 관련 데이터베이스 작업을 담당하는 서비스
class DriftUserService {
  final AppDatabase db;

  DriftUserService(this.db);

  /// 🔍 사용자 조회
  Future<LocalUser?> getUser(String uid) async {
    return await db.getUser(uid);
  }

  /// ✍️ 사용자 생성 또는 업데이트
  Future<void> insertOrUpdateUser(UsersCompanion user) async {
    await db.insertOrUpdateUser(user);
  }

  /// 📍 현재 위치 업데이트
  Future<void> updateCurrentLocation(String uid, double lat, double lng) async {
    await db.updateCurrentLocation(uid, lat, lng);
  }

  /// 🎯 새로운 지역 방문
  Future<void> visitNewRegion(String uid, String regionId) async {
    final user = await getUser(uid);
    if (user == null) return;

    final visitedRegions = user.visitedRegions.split(',').where((s) => s.isNotEmpty).toList();

    if (!visitedRegions.contains(regionId)) {
      visitedRegions.add(regionId);

      await (db.update(db.users)..where((tbl) => tbl.uid.equals(uid))).write(
        UsersCompanion(
          visitedRegions: Value(visitedRegions.join(',')),
          totalVisitedCount: Value(visitedRegions.length),
          explorationProgress: Value(visitedRegions.length / 1000.0), // 예시: 총 1000개 지역
        ),
      );
    }
  }

  /// 📊 탐험 통계 조회
  Future<Map<String, dynamic>> getExplorationStats(String uid) async {
    final user = await getUser(uid);
    if (user == null) {
      return {
        'totalVisited': 0,
        'progress': 0.0,
        'visitedRegions': <String>[],
      };
    }

    return {
      'totalVisited': user.totalVisitedCount,
      'progress': user.explorationProgress,
      'visitedRegions': user.visitedRegions.split(',').where((s) => s.isNotEmpty).toList(),
    };
  }

  /// 🗺️ 방문한 지역 목록 조회
  Future<List<String>> getVisitedRegions(String uid) async {
    final user = await getUser(uid);
    if (user == null) return [];

    return user.visitedRegions.split(',').where((s) => s.isNotEmpty).toList();
  }

  /// 🔄 동기화 시간 업데이트
  Future<void> updateSyncTime(String uid) async {
    await db.updateSyncTime(uid);
  }

  /// 🗑️ 사용자 삭제
  Future<void> deleteUser(String uid) async {
    await db.deleteUser(uid);
  }
}