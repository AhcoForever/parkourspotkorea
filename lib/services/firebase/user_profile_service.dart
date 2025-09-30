import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class UserProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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

  /// 기존 프로필 이미지 삭제
  Future<bool> _deleteOldProfileImage(String? oldImageUrl) async {
    if (oldImageUrl == null || oldImageUrl.isEmpty) {
      return true; // 삭제할 이미지가 없으면 성공으로 처리
    }

    try {
      // Firebase Storage URL에서 파일 경로 추출
      final Uri uri = Uri.parse(oldImageUrl);
      final String path = uri.pathSegments.skip(3).join('/'); // /v0/b/bucket/o/ 이후 경로
      final String decodedPath = Uri.decodeComponent(path);

      final Reference ref = _storage.ref().child(decodedPath);
      await ref.delete();

      print('✅ 기존 프로필 이미지 삭제 완료: $decodedPath');
      return true;
    } catch (e) {
      print('⚠️ 기존 프로필 이미지 삭제 실패 (계속 진행): $e');
      return true; // 삭제 실패해도 새 이미지 업로드는 계속 진행
    }
  }

  /// 프로필 이미지 업로드
  Future<String?> uploadProfileImage(File imageFile) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        print('❌ 사용자가 로그인되어 있지 않음');
        _showErrorToast('로그인이 필요합니다.');
        return null;
      }

      print('🔄 프로필 이미지 업로드 시작...');

      // 파일 확장자 확인
      final fileExtension = imageFile.path.split('.').last.toLowerCase();
      if (!['jpg', 'jpeg', 'png', 'webp'].contains(fileExtension)) {
        _showErrorToast('지원하지 않는 이미지 형식입니다.');
        return null;
      }

      // 고정된 파일명 사용 (사용자당 하나의 프로필 이미지만 유지)
      final fileName = 'profile_${currentUser.uid}.$fileExtension';

      // Firebase Storage에 업로드
      final storageRef = _storage
          .ref()
          .child('profile_images')
          .child(fileName);

      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask;

      if (snapshot.state == TaskState.success) {
        final downloadUrl = await snapshot.ref.getDownloadURL();
        print('✅ 이미지 업로드 성공: $downloadUrl');
        return downloadUrl;
      } else {
        print('❌ 이미지 업로드 실패');
        _showErrorToast('이미지 업로드에 실패했습니다.');
        return null;
      }
    } catch (e) {
      print('❌ 프로필 이미지 업로드 오류: $e');
      _showErrorToast('이미지 업로드에 실패했습니다: ${e.toString()}');
      return null;
    }
  }

  /// 프로필 이미지 URL 업데이트
  Future<bool> updateProfileImageUrl(String imageUrl) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        _showErrorToast('로그인이 필요합니다.');
        return false;
      }

      print('🔄 프로필 이미지 URL 업데이트 중...');

      // Firestore의 사용자 문서 업데이트
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'profileImageUrl': imageUrl,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      print('✅ 프로필 이미지 URL 업데이트 완료');
      _showSuccessToast('프로필 이미지가 변경되었습니다.');
      return true;
    } catch (e) {
      print('❌ 프로필 이미지 URL 업데이트 오류: $e');
      _showErrorToast('프로필 이미지 변경에 실패했습니다.');
      return false;
    }
  }

  /// 프로필 이미지 업로드 및 URL 업데이트 (통합 메서드)
  Future<bool> updateProfileImage(File imageFile) async {
    try {
      // 1. 현재 프로필에서 기존 이미지 URL 가져오기
      final currentProfile = await getCurrentUserProfile();
      final oldImageUrl = currentProfile?['profileImageUrl'] as String?;

      // 2. 기존 이미지가 있다면 삭제
      if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
        print('🔄 기존 프로필 이미지 삭제 중...');
        await _deleteOldProfileImage(oldImageUrl);
      }

      // 3. 새 이미지 업로드
      final imageUrl = await uploadProfileImage(imageFile);
      if (imageUrl == null) {
        return false;
      }

      // 4. URL을 Firestore에 저장
      return await updateProfileImageUrl(imageUrl);
    } catch (e) {
      print('❌ 프로필 이미지 업데이트 오류: $e');
      _showErrorToast('프로필 이미지 변경에 실패했습니다.');
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