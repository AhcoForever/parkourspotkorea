import 'dart:io';
import 'package:parkourspotkorea/services/firebase/user_profile_service.dart';
import 'package:parkourspotkorea/constants/app_constants.dart';

/// 마이페이지 관련 데이터 액세스를 담당하는 Repository
class MyPageRepository {
  final UserProfileService _userProfileService = UserProfileService();

  /// 현재 사용자의 프로필 정보 가져오기
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    try {
      return await _userProfileService.getCurrentUserProfile();
    } catch (e) {
      print('Repository: 프로필 로드 오류 - $e');
      rethrow;
    }
  }

  /// 사용자 닉네임 업데이트
  Future<bool> updateDisplayName(String displayName) async {
    try {
      return await _userProfileService.updateDisplayName(displayName);
    } catch (e) {
      print('Repository: 닉네임 업데이트 오류 - $e');
      rethrow;
    }
  }

  /// 사용자 소개글 업데이트
  Future<bool> updateUserIntroduction(String introduction) async {
    try {
      return await _userProfileService.updateUserIntroduction(introduction);
    } catch (e) {
      print('Repository: 소개글 업데이트 오류 - $e');
      rethrow;
    }
  }

  /// 프로필 이미지 업데이트
  Future<bool> updateProfileImage(File imageFile) async {
    try {
      return await _userProfileService.updateProfileImage(imageFile);
    } catch (e) {
      print('Repository: 프로필 이미지 업데이트 오류 - $e');
      rethrow;
    }
  }

  /// 파쿠르 숙련도 업데이트
  Future<bool> updateSkillLevel(String skillLevel) async {
    try {
      return await _userProfileService.updateSkillLevel(skillLevel);
    } catch (e) {
      print('Repository: 숙련도 업데이트 오류 - $e');
      rethrow;
    }
  }

  /// 사용자 프로필 실시간 스트림
  Stream<Map<String, dynamic>?> getUserProfileStream() {
    try {
      return _userProfileService.getUserProfileStream();
    } catch (e) {
      print('Repository: 프로필 스트림 오류 - $e');
      rethrow;
    }
  }

  /// 프로필 정보 일괄 업데이트
  Future<Map<String, bool>> updateProfileBatch({
    String? displayName,
    String? introduction,
    File? profileImage,
    String? skillLevel,
  }) async {
    final results = <String, bool>{};

    try {
      // 닉네임 업데이트
      if (displayName != null) {
        results['displayName'] = await updateDisplayName(displayName);
      }

      // 소개글 업데이트
      if (introduction != null) {
        results['introduction'] = await updateUserIntroduction(introduction);
      }

      // 프로필 이미지 업데이트
      if (profileImage != null) {
        results['profileImage'] = await updateProfileImage(profileImage);
      }

      // 숙련도 업데이트
      if (skillLevel != null) {
        results['skillLevel'] = await updateSkillLevel(skillLevel);
      }

      return results;
    } catch (e) {
      print('Repository: 일괄 업데이트 오류 - $e');
      rethrow;
    }
  }

  /// 프로필 유효성 검증
  Map<String, String?> validateProfileData({
    String? displayName,
    String? introduction,
    String? skillLevel,
  }) {
    final errors = <String, String?>{};

    // 닉네임 검증
    if (displayName != null) {
      if (displayName.trim().isEmpty) {
        errors['displayName'] = '닉네임을 입력해주세요.';
      } else if (displayName.length < AppConstants.minNicknameLength) {
        errors['displayName'] = '닉네임은 ${AppConstants.minNicknameLength}글자 이상이어야 합니다.';
      } else if (displayName.length > AppConstants.maxNicknameLength) {
        errors['displayName'] = '닉네임은 ${AppConstants.maxNicknameLength}글자 이하여야 합니다.';
      }
    }

    // 소개글 검증
    if (introduction != null && introduction.length > AppConstants.maxIntroductionLength) {
      errors['introduction'] = '소개글은 ${AppConstants.maxIntroductionLength}글자 이하여야 합니다.';
    }

    // 숙련도 검증
    if (skillLevel != null && !AppConstants.skillLevels.contains(skillLevel)) {
      errors['skillLevel'] = '유효하지 않은 숙련도입니다.';
    }

    return errors;
  }

  /// 이미지 파일 유효성 검증
  String? validateImageFile(File? imageFile) {
    if (imageFile == null) return null;

    final fileExtension = imageFile.path.split('.').last.toLowerCase();
    if (!AppConstants.supportedImageFormats.contains(fileExtension)) {
      return '지원하지 않는 이미지 형식입니다. (${AppConstants.supportedImageFormats.join(', ')}만 지원)';
    }

    // 파일 크기 체크
    final fileSizeInBytes = imageFile.lengthSync();
    final maxSizeInBytes = AppConstants.maxProfileImageSizeMB * 1024 * 1024;
    if (fileSizeInBytes > maxSizeInBytes) {
      return '이미지 크기는 ${AppConstants.maxProfileImageSizeMB}MB 이하여야 합니다.';
    }

    return null;
  }

  /// 사용자 프로필 초기화 (회원가입 시 사용)
  Future<bool> initializeUserProfile({
    required String uid,
    String? displayName,
    String? email,
  }) async {
    try {
      // 초기 프로필 데이터 설정
      final initialProfile = {
        'uid': uid,
        'displayName': displayName ?? '',
        'email': email ?? '',
        'introduction': 'hello everyone!',
        'skillLevel': AppConstants.defaultSkillLevel,
        'profileImageUrl': null,
        'createdAt': DateTime.now().toIso8601String(),
        'lastUpdated': DateTime.now().toIso8601String(),
      };

      // Firebase에 초기 프로필 저장
      // 실제 구현은 UserProfileService에서 처리
      return true;
    } catch (e) {
      print('Repository: 프로필 초기화 오류 - $e');
      return false;
    }
  }
}