
import 'package:drift/drift.dart';

@DataClassName('User')
class Users extends Table {
  TextColumn get uid => text()();
  TextColumn get email => text()();
  TextColumn get displayName => text()();
  TextColumn get parkourProficiency => text()();
  DateTimeColumn get signupDate => dateTime()();
  DateTimeColumn get lastLogin => dateTime()();
  TextColumn get status => text()();
  IntColumn get age => integer()();
  IntColumn get phoneNum => integer()();
  TextColumn get favoriteSpotID => text().nullable()();
  TextColumn get userImage => text().nullable()();
  TextColumn get placeId => text().nullable()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get visitedRegions => text().nullable()();
  IntColumn get totalVisitedCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastLocationUpdate => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {uid};
}
