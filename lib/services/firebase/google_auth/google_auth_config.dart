import 'dart:io' show Platform;

/// Google Sign-In 설정
class GoogleAuthConfig {
  // 플랫폼별 클라이언트 ID
  static String get clientId {
    if (Platform.isAndroid) {
      return '1095125086960-v0vqn08vt4c89p2viul7rg909l19hcej.apps.googleusercontent.com';
    } else if (Platform.isIOS) {
      return '1095125086960-9pp9lm12f4ktbslqgeim7g8t8ksgmam3.apps.googleusercontent.com';
    } else {
      throw UnsupportedError('지원되지 않는 플랫폼입니다.');
    }
  }

  // 서버 클라이언트 ID (백엔드 인증용)
  static const String serverClientId =
      '1095125086960-o6km1nffgub8gh2na1h1fdope3rdihrh.apps.googleusercontent.com';

  // 요청할 권한 스코프
  static const List<String> scopes = ['email', 'profile'];
}