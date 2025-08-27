import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/firebase/auth_service.dart';

class NicknameRepository {
  final AuthService _authService;

  NicknameRepository({AuthService? authService})
      : _authService = authService ?? AuthService();

  /// 닉네임 중복 확인
  Future<bool> checkNicknameAvailable(String nickname) async {
    try {
      // Firestore에서 닉네임 중복 확인
      final result = await FirebaseFirestore.instance
          .collection('users')
          .where('displayName', isEqualTo: nickname)
          .get();

      return result.docs.isEmpty;
    } catch (e) {
      return false;
    }
  }

  /// 닉네임 설정/업데이트
  Future<void> updateNickname(String uid, String nickname) async {
    try {
      // Firebase Auth 프로필 업데이트
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateDisplayName(nickname);
      }

      // Firestore 사용자 문서 업데이트
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'displayName': nickname});

    } catch (e) {
      throw Exception('닉네임 설정에 실패했습니다: ${e.toString()}');
    }
  }
}
