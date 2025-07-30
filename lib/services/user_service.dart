import 'package:drift/drift.dart';

import '../database/app_database.dart';


class UserService {
  static final AppDatabase _database = AppDatabase();

  static AppDatabase get database => _database;

  /// 새 사용자 생성
  static Future<void> createUser({
    required String uid,
    required String email,
    required String displayName,
    required String parkourProficiency,
    required int phoneNum,
    required double latitude,
    required double longitude,
  }) async {
    final user = UsersCompanion(
      uid: Value(uid),
      email: Value(email),
      displayName: Value(displayName),
      parkourProficiency: Value(parkourProficiency),
      signupDate: Value(DateTime.now()),
      lastLogin: Value(DateTime.now()),
      phoneNum: Value(phoneNum),
      latitude: Value(latitude),
      longitude: Value(longitude),
    );

    await _database.insertOrUpdateUser(user);
  }

  /// 사용자 정보 업데이트
  static Future<void> updateUser(String uid, {
    String? displayName,
    String? parkourProficiency,
    String? userImage,
  }) async {
    await (_database.update(_database.users)
      ..where((tbl) => tbl.uid.equals(uid)))
        .write(UsersCompanion(
      displayName: displayName != null ? Value(displayName) : const Value.absent(),
      parkourProficiency: parkourProficiency != null ? Value(parkourProficiency) : const Value.absent(),
      userImage: userImage != null ? Value(userImage) : const Value.absent(),
      lastLogin: Value(DateTime.now()),
    ));
  }

  /// 현재 위치 업데이트
  static Future<void> updateLocation(String uid, double lat, double lng) async {
    await _database.updateUserLocation(uid, lat, lng);
  }

  /// 지역 방문 처리
  static Future<void> visitRegion(String uid, String regionId) async {
    await _database.addVisitedRegion(uid, regionId);
  }

  /// 사용자 조회
  static Future<LocalUser?> getUser(String uid) async {
    return await _database.getUser(uid);
  }

  /// 탐험 통계
  static Future<Map<String, dynamic>?> getStats(String uid) async {
    return await _database.getExplorationStats(uid);
  }

  /// 방문한 지역인지 확인
  static Future<bool> hasVisited(String uid, String regionId) async {
    return await _database.hasVisitedRegion(uid, regionId);
  }

  /// 방문 기록 초기화
  static Future<void> clearVisited(String uid) async {
    await _database.clearVisitedRegions(uid);
  }

  /// 데이터베이스 종료
  static Future<void> close() async {
    await _database.close();
  }
}