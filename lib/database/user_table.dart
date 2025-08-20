import 'package:drift/drift.dart';

/// 사용자 테이블 정의
@DataClassName('LocalUser')
class Users extends Table {
  TextColumn get uid => text()();
  TextColumn get email => text()();
  RealColumn get currentLatitude => real().named('current_latitude')();
  RealColumn get currentLongitude => real().named('current_longitude')();

  /// 방문한 지역 ID들 (comma-separated string)
  /// 예: "11110,11140,11170" (서울 종로구, 중구, 용산구)
  TextColumn get visitedRegions => text().named('visited_regions').withDefault(const Constant(''))();
  IntColumn get totalVisitedCount => integer().named('total_visited_count').withDefault(const Constant(0))();
  RealColumn get explorationProgress => real().named('exploration_progress').withDefault(const Constant(0.0))();
  DateTimeColumn get lastLocationUpdate => dateTime().named('last_location_update').nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get lastSyncAt => dateTime().named('last_sync_at').nullable()();

  @override
  Set<Column> get primaryKey => {uid};
}

/// 폴리곤 캐시 테이블 정의
@DataClassName('PolygonRow')
class Polygons extends Table {
  TextColumn get docId => text().named('doc_id')();
  IntColumn get sido => integer()();
  IntColumn get sggPrefix => integer().named('sgg_prefix').nullable()();
  TextColumn get coordinatesJson => text().named('coordinates_json')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column> get primaryKey => {docId};
}