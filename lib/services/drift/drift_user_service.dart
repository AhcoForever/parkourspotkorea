// 사용자  생성, 조회, 수정, 방문 이력 관리
import 'package:drift/drift.dart';
import 'package:parkourspotkorea/database/app_database.dart';

class DriftUserService {
  final AppDatabase db;

  DriftUserService(this.db);
  Future<List<String>> getVisitedRegions(String uid) async {
    final user = await db.getUser(uid);
    if (user == null) return [];
    return _parseVisitedRegions(user.visitedRegions);
  }
Future<LocalUser?> getUser(String uid) => db.getUser(uid);



  Future<void> insertOrUpdateUser(UsersCompanion user) =>
      db.insertOrUpdateUser(user);
  Future<void> updateSyncTime(String uid) => db.updateSyncTime(uid);
  Future<void> updateCurrentLocation(String uid, double lat, double lng) =>
      db.updateCurrentLocation(uid, lat, lng);

  Future<void> deleteUser(String uid) => db.deleteUser(uid);

  Future<Map<String, dynamic>> getExplorationStats(String uid) async {
    final user = await db.getUser(uid);
    if (user == null) return {};
    final visited = _parseVisitedRegions(user.visitedRegions);
    return {
      'totalVisited': user.totalVisitedCount,
      'progress': user.explorationProgress,
      'lastUpdate': user.lastLocationUpdate,
      'visitedRegions': visited,
    };
  }


  Future<void> visitNewRegion(String uid, String regionId) async {
    final user = await db.getUser(uid);
    if (user == null) return;

    final visitedList = _parseVisitedRegions(user.visitedRegions);
    if (visitedList.contains(regionId)) return; // 이미 방문

    visitedList.add(regionId);
    final newCount = visitedList.length;

    // TODO: 전체 지역 수는 상수/설정으로 분리
    const totalRegions = 3500;
    final progress = (newCount / totalRegions) * 100;

    await (db.update(db.users)..where((tbl) => tbl.uid.equals(uid))).write(
      UsersCompanion(
        visitedRegions: Value(visitedList.join(',')),
        totalVisitedCount: Value(newCount),
        explorationProgress: Value(progress),
      ),
    );
  }

  // ── 유틸 ────────────────────────────────────────────────────────────────
  List<String> _parseVisitedRegions(String regions) {
    if (regions.isEmpty) return [];
    return regions.split(',').where((s) => s.isNotEmpty).toList();
  }
}
