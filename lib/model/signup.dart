// lib/models/signup_model.dart

/// 회원가입 요청 데이터 모델
class SignupRequest {
  final String email;
  final String password;
  final String confirmPassword;
  final String phoneNumber;
  //final String displayName;
  final String parkourProficiency;

  SignupRequest({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phoneNumber,
  // required this.displayName,
    required this.parkourProficiency,
  });

  // 유효성 검사
  bool get isValid {
    return email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        phoneNumber.isNotEmpty;
  }

  // 이메일 형식 검사
  bool get isEmailValid {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // 비밀번호 형식 검사
  bool get isPasswordValid {
    final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,16}$');
    return passwordRegex.hasMatch(password);
  }

  // 비밀번호 일치 검사
  bool get isPasswordMatched => password == confirmPassword;

  // 전화번호 형식 검사
  bool get isPhoneValid {
    final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    return cleanedNumber.length == 11 && cleanedNumber.startsWith('010');
  }
}

/// 약관 동의 상태 모델
class TermsAgreement {
  final bool agreeToAll;
  final bool isAdult;
  final bool agreeToService;
  final bool agreeToPrivacy;
  final bool agreeToLocation;

  const TermsAgreement({
    this.agreeToAll = false,
    this.isAdult = false,
    this.agreeToService = false,
    this.agreeToPrivacy = false,
    this.agreeToLocation = false,
  });

  // 모든 필수 약관에 동의했는지 확인
  bool get allRequiredAgreed => isAdult && agreeToService && agreeToPrivacy && agreeToLocation;

  TermsAgreement copyWith({
    bool? agreeToAll,
    bool? isAdult,
    bool? agreeToService,
    bool? agreeToPrivacy,
    bool? agreeToLocation,
  }) {
    return TermsAgreement(
      agreeToAll: agreeToAll ?? this.agreeToAll,
      isAdult: isAdult ?? this.isAdult,
      agreeToService: agreeToService ?? this.agreeToService,
      agreeToPrivacy: agreeToPrivacy ?? this.agreeToPrivacy,
      agreeToLocation: agreeToLocation ?? this.agreeToLocation,
    );
  }

  // 전체 동의 시 모든 약관을 동의 상태로 변경
  TermsAgreement agreeAll() {
    return const TermsAgreement(
      agreeToAll: true,
      isAdult: true,
      agreeToService: true,
      agreeToPrivacy: true,
      agreeToLocation: true,
    );
  }

  // 전체 동의 해제 시 모든 약관을 비동의 상태로 변경
  TermsAgreement disagreeAll() {
    return const TermsAgreement(
      agreeToAll: false,
      isAdult: false,
      agreeToService: false,
      agreeToPrivacy: false,
      agreeToLocation: false,
    );
  }
}

/// 회원가입 상태를 나타내는 enum
enum SignupStatus {
  initial,
  loading,
  success,
  error,
}

/// 회원가입 상태 모델
class SignupState {
  final SignupStatus status;
  final String? errorMessage;
  final TermsAgreement termsAgreement;

  const SignupState({
    this.status = SignupStatus.initial,
    this.errorMessage,
    this.termsAgreement = const TermsAgreement(),
  });

  SignupState copyWith({
    SignupStatus? status,
    String? errorMessage,
    TermsAgreement? termsAgreement,
  }) {
    return SignupState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      termsAgreement: termsAgreement ?? this.termsAgreement,
    );
  }
}