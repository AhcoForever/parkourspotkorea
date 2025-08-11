import '../../database/app_database.dart';

class DriftMapService {
  AppDatabase db = AppDatabase();

  Future<List<PolygonRow>> getPolygonsBySido(int sido) {
    return (db.select(db.polygons)..where((t) => t.sido.equals(sido))).get();
  }


}
