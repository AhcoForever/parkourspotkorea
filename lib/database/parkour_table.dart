// lib/database/parkour_table.dart (대안)

import 'package:drift/drift.dart';

@DataClassName('ParkourSpotEntity')
class ParkourSpots extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get address => text().nullable()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get category => text().withDefault(const Constant('general'))();
  TextColumn get difficulty => text().nullable()();
  TextColumn get imageUrls => text().withDefault(const Constant('[]'))();
  TextColumn get tags => text().withDefault(const Constant('[]'))();
  RealColumn get rating => real().withDefault(const Constant(0.0))();
  IntColumn get reviewCount => integer().withDefault(const Constant(0))();
  BoolColumn get isVerified => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ParkourSpotIndexEntity') // 데이터 클래스 이름 변경
class ParkourSpotIndices extends Table {
  TextColumn get spotId => text()();
  TextColumn get searchTerm => text()();
  IntColumn get termType => integer()();

  @override
  Set<Column> get primaryKey => {spotId, searchTerm, termType};
}