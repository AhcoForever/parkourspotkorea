import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../model/nickname_model.dart';
import '../repositories/nickname_repository.dart';

class NicknameViewModel extends ChangeNotifier {
  final NicknameRepository _repository;

  NicknameViewModel({NicknameRepository? repository})
      : _repository = repository ?? NicknameRepository();

  NicknameState _state = NicknameState();
  NicknameState get state => _state;

  String _nickname = '';
  String get nickname => _nickname;

  bool get canProceed =>
      _nickname.isNotEmpty &&
          _state.status == NicknameStatus.available;

  /// 닉네임 업데이트
  void updateNickname(String nickname) {
    _nickname = nickname;
    _state = _state.copyWith(status: NicknameStatus.initial);
    notifyListeners();
  }

  /// 닉네임 중복 확인
  Future<void> checkNickname() async {
    if (_nickname.isEmpty || _nickname.length < 2) {
      _state = _state.copyWith(
        status: NicknameStatus.error,
        errorMessage: '닉네임은 2자 이상 입력해주세요.',
        isAvailable: false,
      );
      notifyListeners();
      return;
    }

    _state = _state.copyWith(status: NicknameStatus.checking);
    notifyListeners();

    try {
      final isAvailable = await _repository.checkNicknameAvailable(_nickname);

      _state = _state.copyWith(
        status: isAvailable ? NicknameStatus.available : NicknameStatus.unavailable,
        errorMessage: isAvailable ? null : '이미 사용중인 닉네임입니다.',
        isAvailable: isAvailable,
      );

    } catch (e) {
      _state = _state.copyWith(
        status: NicknameStatus.error,
        errorMessage: '닉네임 확인 중 오류가 발생했습니다.',
        isAvailable: false,
      );
    }

    notifyListeners();
  }

  /// 닉네임 설정 완료
  Future<void> setNickname() async {
    if (!canProceed) return;

    _state = _state.copyWith(status: NicknameStatus.loading);
    notifyListeners();

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception('사용자 정보를 찾을 수 없습니다.');

      await _repository.updateNickname(uid, _nickname);

      _state = _state.copyWith(status: NicknameStatus.success);
      notifyListeners();

    } catch (e) {
      _state = _state.copyWith(
        status: NicknameStatus.error,
        errorMessage: e.toString(),
      );
      notifyListeners();
    }
  }

  void reset() {
    _state = NicknameState();
    _nickname = '';
    notifyListeners();
  }
}