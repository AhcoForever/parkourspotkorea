import 'package:drift/drift.dart';

@DataClassName('LocalUser')
class Users extends Table {
  TextColumn get uid => text()();

  TextColumn get email => text()();

  // 현재 위치 좌표
  RealColumn get currentLatitude => real()();

  RealColumn get currentLongitude => real()();

  /// 방문한 지역 ID들 (comma-separated string)
  /// 예: "11110,11140,11170" (서울 종로구, 중구, 용산구)
  TextColumn get visitedRegions => text().withDefault(const Constant(''))();

  // 방문한 지역 개수 (성과 추적용)
  IntColumn get totalVisitedCount => integer().withDefault(const Constant(0))();

  // 탐험 진행률 (전체 대한민국 지역 대비)
  RealColumn get explorationProgress =>
      real().withDefault(const Constant(0.0))();

  // 마지막 위치 업데이트 시간
  DateTimeColumn get lastLocationUpdate => dateTime().nullable()();

  // 계정 생성 시간
  DateTimeColumn get createdAt => dateTime()();

  // Firebase와 마지막 동기화 시간
  DateTimeColumn get lastSyncAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {uid};
}
