import 'package:flutter/material.dart';
import '../model/signup.dart';
import '../repositories/signup_repository.dart';

/// 회원가입 비즈니스 로직을 담당하는 ViewModel
class SignupViewModel extends ChangeNotifier {
  final SignupRepository _repository;

  SignupViewModel({SignupRepository? repository})
      : _repository = repository ?? SignupRepository();

  // 상태 관리
  SignupState _state = const SignupState();

  SignupState get state => _state;

  // 폼 데이터
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _phoneNumber = '';
  String _parkourProficiency = '';

  // 유효성 검사 에러 메시지
  Map<String, String?> _validationErrors = {};
  Map<String, String?> get validationErrors => _validationErrors;

  // Getters
  String get email => _email;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  String get phoneNumber => _phoneNumber;
  String get parkourProficiency => _parkourProficiency;

  bool get isLoading => _state.status == SignupStatus.loading;
  TermsAgreement get termsAgreement => _state.termsAgreement;

  // 회원가입 가능 여부 확인
  bool get canSignUp {
    return _email.isNotEmpty &&
        _password.isNotEmpty &&
        _confirmPassword.isNotEmpty &&
        _phoneNumber.isNotEmpty &&
        _state.termsAgreement.allRequiredAgreed &&
        _validationErrors.isEmpty;
  }

  /// 폼 필드 업데이트 메서드들
  void updateEmail(String email) {
    _email = email;
    _validateField('email');
    notifyListeners();
  }

  void updatePassword(String password) {
    _password = password;
    _validateField('password');
    if (_confirmPassword.isNotEmpty) {
      _validateField('confirmPassword');
    }
    notifyListeners();
  }

  void updateConfirmPassword(String confirmPassword) {
    _confirmPassword = confirmPassword;
    _validateField('confirmPassword');
    notifyListeners();
  }

  void updatePhoneNumber(String phoneNumber) {
    _phoneNumber = phoneNumber;
    _validateField('phoneNumber');
    notifyListeners();
  }


  void updateParkourProficiency(String proficiency) {
    _parkourProficiency = proficiency;
    notifyListeners();
  }

  /// 약관 동의 상태 업데이트
  void updateTermsAgreement({
    bool? agreeToAll,
    bool? isAdult,
    bool? agreeToService,
    bool? agreeToPrivacy,
    bool? agreeToLocation,
  }) {
    if (agreeToAll != null) {
      // 전체 동의/해제
      _state = _state.copyWith(
        termsAgreement: agreeToAll
            ? _state.termsAgreement.agreeAll()
            : _state.termsAgreement.disagreeAll(),
      );
    } else {
      // 개별 약관 동의/해제
      final updatedTerms = _state.termsAgreement.copyWith(
        isAdult: isAdult,
        agreeToService: agreeToService,
        agreeToPrivacy: agreeToPrivacy,
        agreeToLocation: agreeToLocation,
      );

      // 모든 필수 약관이 동의되었는지 확인하여 전체 동의 상태 업데이트
      final agreeToAllUpdated = updatedTerms.allRequiredAgreed;

      _state = _state.copyWith(
        termsAgreement: updatedTerms.copyWith(agreeToAll: agreeToAllUpdated),
      );
    }
    notifyListeners();
  }

  /// 개별 필드 유효성 검사
  void _validateField(String field) {
    final request = _createSignupRequest();

    switch (field) {
      case 'email':
        if (_email.isEmpty) {
          _validationErrors['email'] = '이메일을 입력해주세요.';
        } else if (!request.isEmailValid) {
          _validationErrors['email'] = '올바른 이메일 형식이 아닙니다.';
        } else {
          _validationErrors.remove('email');
        }
        break;

      case 'password':
        if (_password.isEmpty) {
          _validationErrors['password'] = '비밀번호를 입력해주세요.';
        } else if (!request.isPasswordValid) {
          _validationErrors['password'] = '영문+숫자+특수문자 조합 8~16자리로 입력해주세요.';
        } else {
          _validationErrors.remove('password');
        }
        break;

      case 'confirmPassword':
        if (_confirmPassword.isEmpty) {
          _validationErrors['confirmPassword'] = '비밀번호를 다시 입력해주세요.';
        } else if (!request.isPasswordMatched) {
          _validationErrors['confirmPassword'] = '비밀번호가 일치하지 않습니다.';
        } else {
          _validationErrors.remove('confirmPassword');
        }
        break;

      case 'phoneNumber':
        if (_phoneNumber.isEmpty) {
          _validationErrors['phoneNumber'] = '휴대폰 번호를 입력해주세요.';
        } else if (!request.isPhoneValid) {
          _validationErrors['phoneNumber'] = '휴대폰 번호는 010으로 시작하는 11자리 숫자를 입력해주세요.';
        } else {
          _validationErrors.remove('phoneNumber');
        }
        break;
    }
  }

  /// 회원가입 처리
  Future<void> signUp() async {
    if (!canSignUp) return;

    _state = _state.copyWith(status: SignupStatus.loading);
    notifyListeners();

    try {
      final request = _createSignupRequest();

      // 서버사이드 유효성 검사
      final serverValidationErrors = await _repository.validateSignupData(request);
      if (serverValidationErrors.isNotEmpty) {
        _validationErrors.addAll(serverValidationErrors);
        _state = _state.copyWith(
          status: SignupStatus.error,
          errorMessage: '입력 정보를 확인해주세요.',
        );
        notifyListeners();
        return;
      }

      // 회원가입 실행
      await _repository.signUp(request);

      _state = _state.copyWith(status: SignupStatus.success);
      notifyListeners();

    } catch (e) {
      _state = _state.copyWith(
        status: SignupStatus.error,
        errorMessage: e.toString(),
      );
      notifyListeners();
    }
  }

  /// SignupRequest 객체 생성
  SignupRequest _createSignupRequest() {
    return SignupRequest(
      email: _email,
      password: _password,
      confirmPassword: _confirmPassword,
      phoneNumber: _phoneNumber,
      parkourProficiency: _parkourProficiency,
    );
  }

  /// 상태 초기화
  void reset() {
    _state = SignupState();
    _email = '';
    _password = '';
    _confirmPassword = '';
    _phoneNumber = '';
    _parkourProficiency = '';
    _validationErrors.clear();
    notifyListeners();
  }

  /// 에러 메시지 클리어
  void clearError() {
    _state = _state.copyWith(
      status: SignupStatus.initial,
      errorMessage: null,
    );
    notifyListeners();
  }
}