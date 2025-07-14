enum UserStatus { active, inactive, banned }

class User {
  //변수 선언
  final String uid;
  final String email;
  String displayName;
  String parkourProficiency;
  final DateTime signupDate;
  DateTime lastLogin; //서비스 디렉토리
  UserStatus status;
  final int age;
  final int phoneNum;
  List<String> favoriteSpotID;
  String? userImage;
  String? placeId;

  //  생성자
  User({
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
  });

  //map 으로 바꿔주는 함수
  Map<String, dynamic> toMap() {
    return {
      'UID': uid,
      'email': email,
      'displayName': displayName,
      'parkourProficiency': parkourProficiency,
      'signupDate': signupDate,
      'lastLogin': lastLogin,
      'status': status,
      'age': age,
      'phoneNum': phoneNum,
      'favoriteSpotID': favoriteSpotID,
      'userImage': userImage,
      'placeID': placeId,
    };
  }

  //map에서 객체로 바꿔주는 함수
  static User fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? '',
      displayName: map['displayName'] ?? '',
      email: map['email'] ?? '',
      parkourProficiency: map['parkourProficiency'] ?? '',
      signupDate: map['signupDate'] ?? DateTime.now(),
      lastLogin: map['lastLogin'] ?? '',
      status: _statusFromString(map['status']),
      age: map['age'] ?? 0,
      phoneNum: map['phoneNum'] ?? 0,
      favoriteSpotID: List<String>.from(map['favoriteSpotID'] ?? []),
      userImage: map['userImage'] ?? '',
      placeId: map['placeId'] ?? '',
    );
  }

  //사용자 상태
  static UserStatus _statusFromString(String status) {
    switch (status) {
      case 'active':
        return UserStatus.active;
      case 'inactive':
        return UserStatus.inactive;
      case 'banned':
        return UserStatus.banned;
      default:
        return UserStatus.inactive; //기본값
    }
  }
}
