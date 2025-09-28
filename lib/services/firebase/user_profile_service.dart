import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class UserProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  /// 현재 사용자의 프로필 정보 가져오기
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        print('❌ 현재 로그인된 사용자가 없음');
        return null;
      }

      print('🔍 현재 사용자 UID: ${currentUser.uid}');
      print('🔍 현재 사용자 이메일: ${currentUser.email}');
      print('🔍 현재 사용자 displayName: ${currentUser.displayName}');
      print('🔍 Firestore에서 문서 조회 중... (컬렉션: users, 문서ID: ${currentUser.uid})');

      final doc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      print('🔍 문서 존재 여부: ${doc.exists}');

      if (doc.exists) {
        final data = doc.data();
        print('✅ 문서 데이터: $data');
        return data;
      } else {
        print('❌ 문서가 존재하지 않음');
        // 혹시 uid로 쿼리해서 찾아보기
        print('🔍 uid 필드로 문서 검색 중...');
        final querySnapshot = await _firestore
            .collection('users')
            .where('uid', isEqualTo: currentUser.uid)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final foundDoc = querySnapshot.docs.first;
          print('✅ uid 쿼리로 문서 발견: ${foundDoc.id}');
          print('✅ 문서 데이터: ${foundDoc.data()}');
          return foundDoc.data();
        } else {
          print('❌ uid 쿼리로도 문서를 찾을 수 없음');

          // 모든 사용자 문서를 확인해보기
          print('🔍 모든 사용자 문서 확인 중...');
          final allUsersSnapshot = await _firestore.collection('users').get();
          print('📄 총 사용자 문서 개수: ${allUsersSnapshot.docs.length}');

          for (var doc in allUsersSnapshot.docs) {
            print('📄 문서 ID: ${doc.id}, UID 필드: ${doc.data()['uid']}, 이메일: ${doc.data()['email']}');
          }
        }
      }
      return null;
    } catch (e) {
      print('❌ 사용자 프로필 조회 오류: $e');
      return null;
    }
  }

  /// 사용자 닉네임 업데이트
  Future<bool> updateDisplayName(String newDisplayName) async {
    try {
      final currentUser = _auth.currentUser;
      print('🔍 현재 사용자: ${currentUser?.uid}');

      if (currentUser == null) {
        print('❌ 사용자가 로그인되어 있지 않음');
        _showErrorToast('로그인이 필요합니다.');
        return false;
      }

      if (newDisplayName.trim().isEmpty) {
        print('❌ 빈 닉네임');
        _showErrorToast('닉네임을 입력해주세요.');
        return false;
      }

      if (newDisplayName.length < 2) {
        print('❌ 닉네임이 너무 짧음: ${newDisplayName.length}글자');
        _showErrorToast('닉네임은 2글자 이상이어야 합니다.');
        return false;
      }

      if (newDisplayName.length > 12) {
        print('❌ 닉네임이 너무 김: ${newDisplayName.length}글자');
        _showErrorToast('닉네임은 12글자 이하여야 합니다.');
        return false;
      }

      print('✅ 닉네임 유효성 검사 통과: "$newDisplayName"');

      // Firebase Auth의 displayName도 업데이트
      print('🔄 Firebase Auth displayName 업데이트 중...');
      await currentUser.updateDisplayName(newDisplayName);
      print('✅ Firebase Auth displayName 업데이트 완료');

      // Firestore의 사용자 문서 업데이트
      print('🔄 Firestore 문서 업데이트 중... (uid: ${currentUser.uid})');
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'displayName': newDisplayName,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      print('✅ Firestore 문서 업데이트 완료');

      _showSuccessToast('닉네임이 변경되었습니다.');
      return true;
    } catch (e) {
      print('❌ 닉네임 업데이트 오류: $e');
      print('❌ 오류 타입: ${e.runtimeType}');
      if (e.toString().contains('permission')) {
        _showErrorToast('권한이 없습니다. Firestore 보안 규칙을 확인해주세요.');
      } else if (e.toString().contains('network')) {
        _showErrorToast('네트워크 연결을 확인해주세요.');
      } else {
        _showErrorToast('닉네임 변경에 실패했습니다: ${e.toString()}');
      }
      return false;
    }
  }

  /// 사용자 소개글 업데이트
  Future<bool> updateUserIntroduction(String introduction) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        _showErrorToast('로그인이 필요합니다.');
        return false;
      }

      if (introduction.length > 200) {
        _showErrorToast('소개글은 200글자 이하여야 합니다.');
        return false;
      }

      // Firestore의 사용자 문서 업데이트
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'introduction': introduction,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      _showSuccessToast('소개글이 변경되었습니다.');
      return true;
    } catch (e) {
      print('❌ 소개글 업데이트 오류: $e');
      _showErrorToast('소개글 변경에 실패했습니다.');
      return false;
    }
  }

  /// 사용자 프로필 실시간 스트림
  Stream<Map<String, dynamic>?> getUserProfileStream() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.value(null);
    }

    return _firestore
        .collection('users')
        .doc(currentUser.uid)
        .snapshots()
        .map((doc) => doc.exists ? doc.data() : null);
  }

  void _showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}