import '../database/app_database.dart';
class AppDB {
  AppDB._();

  // 앱 전체에서 하나만 쓰는 인스턴스..
  static final AppDatabase instance = AppDatabase();
}
//싱글톤?!