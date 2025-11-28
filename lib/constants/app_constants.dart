class AppConstants {
  // 앱 버전 정보
  static const String appVersion = '1.0.1';
  static const String appName = 'Parkour Spot Korea';

  // 앱 정보
  static const String appDescription = 'Parkour Spot Finder Korea';

  // 개발자 정보
  static const String developerName = 'Minyoung Kim';
  static const String supportEmail = 'ahco8766@kakao.com';

  // 앱 설정
  static const int maxProfileImageSizeMB = 10;
  static const int maxNicknameLength = 12;
  static const int minNicknameLength = 2;
  static const int maxIntroductionLength = 200;

  // 파쿠르 숙련도
  static const List<String> skillLevels = ['트레이서', '프리러너', '야막'];
  static const String defaultSkillLevel = '트레이서';

  // 지원하는 이미지 형식
  static const List<String> supportedImageFormats = ['jpg', 'jpeg', 'png', 'webp'];
}