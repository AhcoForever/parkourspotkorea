import 'dart:math' as math;

import 'package:drift/drift.dart';

enum UserStatus { active, inactive, banned }

class Users {
  //변수 선언
  final String uid;
  final String email;
  String displayName;
  String parkourProficiency;
  final DateTime signupDate;
  DateTime lastLogin; //서비스 디렉토리로 따로 분류하는 것이 좋다.
  UserStatus status;
  final int age;
  final int phoneNum;
  List<String> favoriteSpotID;
  String? userImage;
  String? placeId;

  List<String> visitedRegions; //방문한 지역 ID들
  double latitude; //위도
  double longitude; //경도
  int totalVisitedCount;
  DateTime? lastLocationUpdate; //마지막 위치 업데이트 시간

  //  생성자
  Users({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.parkourProficiency,
    required this.signupDate,
    required this.lastLogin,
    required this.status,
    required this.age,
    required this.phoneNum,
    this.favoriteSpotID = const [],
    this.userImage,
    this.placeId,
    required this.latitude,
    required this.longitude,
    this.visitedRegions = const [],
    this.totalVisitedCount = 0,
    this.lastLocationUpdate,
  });

  //map 으로 바꿔주는 함수
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'parkourProficiency': parkourProficiency,
      'signupDate': signupDate,
      'lastLogin': lastLogin,
      'status': status.name,
      'age': age,
      'phoneNum': phoneNum,
      'favoriteSpotID': favoriteSpotID,
      'userImage': userImage,
      'placeID': placeId,
      'latitude': latitude,
      'longitude': longitude,
      'visitedRegions': visitedRegions.join(','),
      'totalVisitedCount': totalVisitedCount,
      'lastLocationUpdate': lastLocationUpdate?.millisecondsSinceEpoch,
    };
  }

  //map에서 객체로 바꿔주는 함수
  static Users fromMap(Map<String, dynamic> map) {
    return Users(
      uid: map['uid'] ?? '',
      displayName: map['displayName'] ?? '',
      email: map['email'] ?? '',
      parkourProficiency: map['parkourProficiency'] ?? '',
      signupDate: map['signupDate'] ?? DateTime.now(),
      lastLogin: map['lastLogin'] ?? '',
      status: statusFromString(map['status']),
      age: map['age'] ?? 0,
      phoneNum: map['phoneNum'] ?? 0,
      favoriteSpotID: List<String>.from(map['favoriteSpotID'] ?? []),
      userImage: map['userImage'] ?? '',
      placeId: map['placeId'] ?? '',
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitdude'] ?? 0.0,
      visitedRegions: _stringToList(map['visitedRegions']),
      totalVisitedCount: map['totalVisitedCount'] ?? 0,
      lastLocationUpdate: map['lastLocationUpdate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastLocationUpdate'])
          : null,
    );
  }

  static List<String> _stringToList(dynamic value) {
    if (value == null || value == '') return [];
    if (value is String) {
      return value.split(',').where((s) => s.isNotEmpty).toList();
    }
    return [];
  }

  //사용자 상태
  static UserStatus statusFromString(String status) {
    switch (status) {
      case 'active':
        return UserStatus.active;
      case 'inactive':
        return UserStatus.inactive;
      case 'banned':
        return UserStatus.banned;
      default:
        return UserStatus.inactive; //기본값은 비활성.
    }
  }

  //새로운 지역 방문 추가
  void addVisitedRegion(String regionId) {
    if (!visitedRegions.contains(regionId)) {
      visitedRegions = [...visitedRegions, regionId];
      totalVisitedCount = visitedRegions.length;
    }
  }

  /// 두 지점 간 거리 계산 (km)
  double _calculateDistance(double lat1,
      double lon1,
      double lat2,
      double lon2,) {
    const double earthRadius = 6371; // 지구 반지름 (km)
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
            math.cos(_degreesToRadians(lat1)) *
                math.cos(_degreesToRadians(lat2)) *
                math.sin(dLon / 2) *
                math.sin(dLon / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }


  /// User 복사본 생성 (일부 필드 업데이트용)
  Users copyWith({
    String? displayName,
    String? parkourProficiency,
    DateTime? lastLogin,
    UserStatus? status,
    List<String>? favoriteSpotID,
    String? userImage,
    String? placeId,
    double? latitude,
    double? longitude,
    List<String>? visitedRegions,
    int? totalVisitedCount,
    int? explorationLevel,
    DateTime? lastLocationUpdate,
    double? totalDistanceTraveled,
  }) {
    return Users(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      parkourProficiency: parkourProficiency ?? this.parkourProficiency,
      signupDate: signupDate,
      lastLogin: lastLogin ?? this.lastLogin,
      status: status ?? this.status,
      age: age,
      phoneNum: phoneNum,
      favoriteSpotID: favoriteSpotID ?? this.favoriteSpotID,
      userImage: userImage ?? this.userImage,
      placeId: placeId ?? this.placeId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      visitedRegions: visitedRegions ?? this.visitedRegions,
      totalVisitedCount: totalVisitedCount ?? this.totalVisitedCount,
      lastLocationUpdate: lastLocationUpdate ?? this.lastLocationUpdate,
    );
  }
}
