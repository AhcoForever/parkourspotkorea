
import '../model/signup.dart';
import '../services/firebase/auth_service.dart';

/// 회원가입 관련 데이터 처리를 담당하는 Repository
class SignupRepository {
  final AuthService _authService;

  SignupRepository({AuthService? authService})
      : _authService = authService ?? AuthService();

  /// 회원가입 처리
  Future<void> signUp(SignupRequest request) async {
    try {
      await _authService.signup(
        email: request.email,
        password: request.password,
        displayName: '',
        parkourProficiency: request.parkourProficiency,
        phoneNum: _parsePhoneNumber(request.phoneNumber),
      );
    } catch (e) {
      throw Exception('회원가입에 실패했습니다: ${e.toString()}');
    }
  }

  Future<bool> checkEmailAvailable(String email) async {
    try {
      // AuthService에 이메일 중복 확인 메서드가 있다면 사용
      //return await _authService.checkEmailAvailable(email);

      // 임시로 true 반환 (실제 구현 시 AuthService에서 처리)
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 전화번호 파싱 (010-1234-5678 → 01012345678)
  int _parsePhoneNumber(String phoneNumber) {
    final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    return int.parse(cleanedNumber);
  }

  /// 유효성 검사 (추가적인 서버사이드 검증이 필요한 경우)
  Future<Map<String, String?>> validateSignupData(SignupRequest request) async {
    Map<String, String?> errors = {};

    // 이메일 형식 검사
    if (!request.isEmailValid) {
      errors['email'] = '올바른 이메일 형식이 아닙니다.';
    }

    // 비밀번호 형식 검사
    if (!request.isPasswordValid) {
      errors['password'] = '영문+숫자+특수문자 조합 8~16자리로 입력해주세요.';
    }

    // 비밀번호 일치 검사
    if (!request.isPasswordMatched) {
      errors['confirmPassword'] = '비밀번호가 일치하지 않습니다.';
    }

    // 전화번호 형식 검사
    if (!request.isPhoneValid) {
      errors['phoneNumber'] = '올바른 전화번호 형식이 아닙니다. (010-0000-0000)';
    }

    // 이메일 중복 검사
    if (request.isEmailValid) {
      final isAvailable = await checkEmailAvailable(request.email);
      if (!isAvailable) {
        errors['email'] = '이미 사용중인 이메일입니다.';
      }
    }

    return errors;
  }
}