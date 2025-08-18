/// 로그인 관련 데이터 모델
class LoginModel {
  final String email;
  final String password;

  LoginModel({
    required this.email,
    required this.password,
  });

  // 유효성 검사
  bool get isValid => email.isNotEmpty && password.isNotEmpty;

  // 이메일 형식 검사
  bool get isEmailValid {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}

/// 로그인 상태를 나타내는 enum
enum LoginStatus {
  initial,
  loading,
  success,
  error,
}

/// 로그인 상태 모델
class LoginState {
  final LoginStatus status;
  final String? errorMessage;
  final bool isGoogleLoading;

  LoginState({
    this.status = LoginStatus.initial,
    this.errorMessage,
    this.isGoogleLoading = false,
  });

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
    bool? isGoogleLoading,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isGoogleLoading: isGoogleLoading ?? this.isGoogleLoading,
    );
  }
}