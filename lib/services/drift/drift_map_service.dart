// 행정구역 경계(polygon) 캐시 테이블에 대한 모든 읽기/쓰기는 이 서비스를 통해 이루어져야 한다.

import '../../database/app_database.dart';

class DriftMapService {
  final AppDatabase db;

  DriftMapService(this.db);

  Future<List<PolygonRow>> getPolygonsBySggPrefix(int sggPrefix) {
    return (db.select(
      db.polygons,
    )..where((t) => t.sggPrefix.equals(sggPrefix))).get();
  }

  Future<List<PolygonRow>> getPolygonsBySido(int sido) {
    return (db.select(db.polygons)..where((t) => t.sido.equals(sido))).get();
  }

  Future<void> upsertPolygonsCompanions(List<PolygonsCompanion> items) async {
    await db.upsertPolygonsCompanions(items);
  }
}
