import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parkourspotkorea/repositories/my_page_repository.dart';
import 'package:parkourspotkorea/constants/app_constants.dart';

class MyPageViewModel extends ChangeNotifier {
  final MyPageRepository _repository = MyPageRepository();
  final ImagePicker _picker = ImagePicker();

  // State variables
  bool _isEditing = false;
  bool _isLoading = true;
  File? _profileImage;
  Map<String, dynamic>? _userProfile;

  // Controllers
  late TextEditingController nicknameController;
  late TextEditingController introController;

  // Getters
  bool get isEditing => _isEditing;
  bool get isLoading => _isLoading;
  File? get profileImage => _profileImage;
  Map<String, dynamic>? get userProfile => _userProfile;

  MyPageViewModel() {
    nicknameController = TextEditingController();
    introController = TextEditingController();
    loadUserProfile();
  }

  @override
  void dispose() {
    nicknameController.dispose();
    introController.dispose();
    super.dispose();
  }

  /// 프로필 이미지 가져오기 (우선순위: 로컬 이미지 > Firebase URL > null)
  ImageProvider? getProfileImage() {
    // 편집 중이고 로컬에 새로 선택한 이미지가 있는 경우
    if (_profileImage != null) {
      return FileImage(_profileImage!);
    }

    // Firebase Storage에서 저장된 이미지 URL이 있는 경우
    if (_userProfile != null && _userProfile!['profileImageUrl'] != null) {
      final imageUrl = _userProfile!['profileImageUrl'] as String;
      if (imageUrl.isNotEmpty) {
        return NetworkImage(imageUrl);
      }
    }

    // 둘 다 없는 경우
    return null;
  }

  /// 이미지 선택
  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _profileImage = File(image.path);
      notifyListeners();
    }
  }

  /// 사용자 프로필 로드
  Future<void> loadUserProfile() async {
    try {
      final profile = await _repository.getCurrentUserProfile();
      if (profile != null) {
        _userProfile = profile;
        nicknameController.text = profile['displayName'] ?? '';
        introController.text = profile['introduction'] ?? 'hello everyone!';
        // 프로필 로드 시 로컬 이미지 초기화 (Firebase에서 가져온 이미지를 우선)
        if (!_isEditing) {
          _profileImage = null;
        }
      } else {
        nicknameController.text = '';
        introController.text = 'hello everyone!';
        _userProfile = null;
        if (!_isEditing) {
          _profileImage = null;
        }
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('프로필 로드 오류: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 편집 모드 토글
  Future<void> toggleEdit() async {
    if (_isEditing) {
      await _saveProfile();
    } else {
      _startEditing();
    }
  }

  /// 프로필 저장 (편집 완료)
  Future<void> _saveProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 입력 검증
      final validationErrors = _repository.validateProfileData(
        displayName: nicknameController.text,
        introduction: introController.text,
      );

      if (validationErrors.isNotEmpty) {
        // 검증 오류가 있으면 저장하지 않음
        print('검증 오류: $validationErrors');
        return;
      }

      // 이미지 파일 검증
      final imageError = _repository.validateImageFile(_profileImage);
      if (imageError != null) {
        print('이미지 검증 오류: $imageError');
        return;
      }

      // 일괄 업데이트 실행
      final results = await _repository.updateProfileBatch(
        displayName: nicknameController.text,
        introduction: introController.text,
        profileImage: _profileImage,
      );

      // 모든 업데이트가 성공했는지 확인
      final allSuccess = results.values.every((success) => success);

      if (allSuccess) {
        _isEditing = false;
        if (_profileImage != null) {
          _profileImage = null; // 업로드 성공 후 로컬 이미지 초기화
        }
        await loadUserProfile(); // 저장 후 새로고침
      } else {
        print('일부 업데이트 실패: $results');
      }
    } catch (e) {
      print('프로필 저장 오류: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 편집 시작
  void _startEditing() {
    _isEditing = true;
    // 편집 시작 시 현재 프로필 정보로 필드 초기화
    if (_userProfile != null) {
      nicknameController.text = _userProfile!['displayName'] ?? '';
      introController.text = _userProfile!['introduction'] ?? 'hello everyone!';
    }
    // 편집 시작 시 로컬 이미지 초기화
    _profileImage = null;
    notifyListeners();
  }

  /// 편집 취소
  void cancelEdit() {
    _isEditing = false;
    // 기존 프로필 정보로 되돌리기
    if (_userProfile != null) {
      nicknameController.text = _userProfile!['displayName'] ?? '';
      introController.text = _userProfile!['introduction'] ?? 'hello everyone!';
    }
    // 선택한 이미지 취소
    _profileImage = null;
    notifyListeners();
  }

  /// 파쿠르 숙련도 업데이트
  Future<void> updateSkillLevel(String skillLevel) async {
    try {
      // 숙련도 검증
      final validationErrors = _repository.validateProfileData(skillLevel: skillLevel);
      if (validationErrors.containsKey('skillLevel')) {
        print('숙련도 검증 오류: ${validationErrors['skillLevel']}');
        return;
      }

      final success = await _repository.updateSkillLevel(skillLevel);
      if (success) {
        await loadUserProfile(); // 프로필 새로고침
      }
    } catch (e) {
      print('숙련도 업데이트 오류: $e');
    }
  }

  /// 숙련도 레벨 옵션 체크
  bool isSkillLevelSelected(String level) {
    return (_userProfile?['skillLevel'] ?? AppConstants.defaultSkillLevel) == level;
  }

  /// 현재 프로필이 완성되었는지 확인
  bool get isProfileComplete {
    if (_userProfile == null) return false;

    final hasNickname = _userProfile!['displayName'] != null &&
                       _userProfile!['displayName'].toString().trim().isNotEmpty;
    final hasIntroduction = _userProfile!['introduction'] != null &&
                           _userProfile!['introduction'].toString().trim().isNotEmpty;
    final hasSkillLevel = _userProfile!['skillLevel'] != null;

    return hasNickname && hasIntroduction && hasSkillLevel;
  }

  /// 현재 프로필 완성도 퍼센트 계산
  int get profileCompletionPercentage {
    if (_userProfile == null) return 0;

    int completedFields = 0;
    const totalFields = 4; // 닉네임, 소개, 숙련도, 프로필 이미지

    // 닉네임 체크
    if (_userProfile!['displayName'] != null &&
        _userProfile!['displayName'].toString().trim().isNotEmpty) {
      completedFields++;
    }

    // 소개글 체크
    if (_userProfile!['introduction'] != null &&
        _userProfile!['introduction'].toString().trim().isNotEmpty &&
        _userProfile!['introduction'] != 'hello everyone!') {
      completedFields++;
    }

    // 숙련도 체크
    if (_userProfile!['skillLevel'] != null) {
      completedFields++;
    }

    // 프로필 이미지 체크
    if (_userProfile!['profileImageUrl'] != null &&
        _userProfile!['profileImageUrl'].toString().isNotEmpty) {
      completedFields++;
    }

    return (completedFields / totalFields * 100).round();
  }

  /// 프로필 데이터 검증 상태
  Map<String, String?> get validationErrors {
    return _repository.validateProfileData(
      displayName: nicknameController.text,
      introduction: introController.text,
    );
  }

  /// 저장 가능 상태 확인
  bool get canSave {
    final errors = validationErrors;
    final imageError = _repository.validateImageFile(_profileImage);

    return errors.isEmpty && imageError == null && !_isLoading;
  }

  /// 이미지 선택 가능 상태
  bool get canPickImage => _isEditing && !_isLoading;

  /// 편집 취소 가능 상태
  bool get canCancelEdit => _isEditing && !_isLoading;
}