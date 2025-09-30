import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parkourspotkorea/theme/app_colors.dart';
import 'package:parkourspotkorea/widgets/background_wrapper.dart';
import 'package:parkourspotkorea/services/firebase/user_profile_service.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  bool isEditing = false;
  late TextEditingController nicknameController;
  late TextEditingController introController;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  final UserProfileService _userProfileService = UserProfileService();
  Map<String, dynamic>? _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    nicknameController = TextEditingController();
    introController = TextEditingController();
    _loadUserProfile();
  }

  @override
  void dispose() {
    nicknameController.dispose();
    introController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  /// 프로필 이미지 가져오기 (우선순위: 로컬 이미지 > Firebase URL > null)
  ImageProvider? _getProfileImage() {
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

  Future<void> _loadUserProfile() async {
    try {
      final profile = await _userProfileService.getCurrentUserProfile();
      if (profile != null) {
        setState(() {
          _userProfile = profile;
          nicknameController.text = profile['displayName'] ?? '';
          introController.text = profile['introduction'] ?? 'hello everyone!';
          // 프로필 로드 시 로컬 이미지 초기화 (Firebase에서 가져온 이미지를 우선)
          if (!isEditing) {
            _profileImage = null;
          }
          _isLoading = false;
        });
      } else {
        setState(() {
          nicknameController.text = '';
          introController.text = 'hello everyone!';
          _userProfile = null;
          if (!isEditing) {
            _profileImage = null;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      print('프로필 로드 오류: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleEdit() async {
    if (isEditing) {
      // 편집 완료 - 저장
      setState(() {
        _isLoading = true;
      });

      try {
        final nicknameSuccess = await _userProfileService.updateDisplayName(
          nicknameController.text,
        );
        final introSuccess = await _userProfileService.updateUserIntroduction(
          introController.text,
        );

        // 프로필 이미지가 변경된 경우 업로드
        bool imageSuccess = true;
        if (_profileImage != null) {
          imageSuccess = await _userProfileService.updateProfileImage(_profileImage!);
          if (imageSuccess) {
            // 업로드 성공 후 로컬 이미지 초기화
            setState(() {
              _profileImage = null;
            });
          }
        }

        if (nicknameSuccess && introSuccess && imageSuccess) {
          setState(() {
            isEditing = false;
          });
          await _loadUserProfile(); // 저장 후 새로고침
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      // 편집 시작
      setState(() {
        isEditing = true;
        // 편집 시작 시 현재 프로필 정보로 필드 초기화
        if (_userProfile != null) {
          nicknameController.text = _userProfile!['displayName'] ?? '';
          introController.text = _userProfile!['introduction'] ?? 'hello everyone!';
        }
        // 편집 시작 시 로컬 이미지 초기화
        _profileImage = null;
      });
    }
  }

  /// 편집 취소
  void _cancelEdit() {
    setState(() {
      isEditing = false;
      // 기존 프로필 정보로 되돌리기
      if (_userProfile != null) {
        nicknameController.text = _userProfile!['displayName'] ?? '';
        introController.text = _userProfile!['introduction'] ?? 'hello everyone!';
      }
      // 선택한 이미지 취소
      _profileImage = null;
    });
  }

  void _showSettingsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: BrandColors.c800,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 드래그 핸들
              Container(
                margin: EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: BrandColors.txt300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // 제목
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  '설정',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: BrandColors.txt30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // 메뉴 아이템들
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildMenuItem('계정 설정', () {
                      Navigator.pop(context);
                      // 계정 설정 로직
                    }),
                    _buildMenuItem('공지사항', () {
                      Navigator.pop(context);
                      // 공지사항 로직
                    }),
                    _buildMenuItem('친구 초대', () {
                      Navigator.pop(context);
                      // 친구 초대 로직
                    }),
                    _buildMenuItem('고객 지원', () {
                      Navigator.pop(context);
                      // 고객 지원 로직
                    }),
                    _buildMenuItem('언어 설정', () {
                      Navigator.pop(context);
                      // 언어 설정 로직
                    }),
                    _buildMenuItem('버전 1.0.0.', () {
                      Navigator.pop(context);
                      // 버전 정보 로직
                    }),
                    _buildMenuItem('로그아웃', () {
                      Navigator.pop(context);
                      // 로그아웃 로직
                    }, underline: true),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: BrandColors.c900,
      appBar: AppBar(
        title: Text(
          '마이 페이지',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: BrandColors.c900,
        foregroundColor: BrandColors.txt30,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: BrandColors.txt30),
            onPressed: _showSettingsBottomSheet,
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: SecondaryColors.c500Default,
                ),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Center(
                  child: BackgroundWrapper(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 프로필 사진 (맨 위)
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: SecondaryColors.c500Default,
                              width: 4,
                            ),
                          ),
                          child: GestureDetector(
                            onTap: isEditing ? _pickImage : null,
                            child: CircleAvatar(
                              radius: 75,
                              backgroundColor: BrandColors.c700,
                              backgroundImage: _getProfileImage(),
                              child: _getProfileImage() == null
                                  ? Icon(
                                      Icons.person,
                                      size: 60,
                                      color: BrandColors.txt300,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),

                        // 닉네임과 편집 아이콘
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: isEditing
                                  ? TextField(
                                      controller: nicknameController,
                                      textAlign: TextAlign.center,
                                      style: textTheme.bodyLarge?.copyWith(
                                        color: BrandColors.txtWhite,
                                        fontSize: 24,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: '닉네임 입력',
                                        hintStyle: TextStyle(
                                          fontSize: 24,
                                          color: BrandColors.txt300,
                                        ),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: StrokeColors.defaultStroke,
                                          ),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: StrokeColors.defaultStroke,
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: SecondaryColors.c500Default,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Text(
                                      nicknameController.text.isEmpty
                                          ? '닉네임을 설정해주세요'
                                          : nicknameController.text,
                                      style: TextStyle(
                                        color: nicknameController.text.isEmpty
                                            ? BrandColors.txt300
                                            : BrandColors.txtWhite,
                                        fontSize: 32,
                                        fontWeight: FontWeight.w700,
                                        height: 1.50,
                                      ),
                                    ),
                            ),
                            if (isEditing) ...[
                              IconButton(
                                icon: Icon(Icons.close, color: BrandColors.txt300),
                                onPressed: _cancelEdit,
                              ),
                              IconButton(
                                icon: Icon(Icons.check, color: BrandColors.c500),
                                onPressed: _toggleEdit,
                              ),
                            ] else
                              IconButton(
                                icon: SvgPicture.asset(
                                  'assets/icons/iconamoon_edit-light.svg',
                                  width: 24,
                                  height: 24,
                                ),
                                onPressed: _toggleEdit,
                              ),
                          ],
                        ),
                        SizedBox(height: 30),
                        isEditing
                            ? TextField(
                                controller: introController,
                                maxLines: 4,
                                style: TextStyle(
                                  color: BrandColors.txtWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: BrandColors.c800,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: BorderSide(
                                      color: StatusColors.notification,
                                    ),
                                  ),

                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: BorderSide(
                                      color: SecondaryColors.c500Default,
                                      width: 2,
                                    ),
                                  ),
                                  hintText: '소개를 입력하세요',
                                  hintStyle: TextStyle(
                                    color: BrandColors.txtWhite,
                                  ),
                                ),
                              )
                            : Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: BrandColors.c800,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  introController.text,
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: BrandColors.txtWhite,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              '파쿠르 숙련도 변경',
                              style: TextStyle(
                                color: BrandColors.txtWhite,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: SecondaryColors.c500Default,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '초급',
                                style: TextStyle(
                                  color: SecondaryColors.c500Default,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.info_outline, color: BrandColors.txt300),
                          ],
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildMenuItem(
    String title,
    VoidCallback onTap, {
    bool underline = false,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: BrandColors.c800,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: StrokeColors.defaultStroke, width: 0.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: textTheme.bodyLarge?.copyWith(
                  color: BrandColors.txt30,
                  decoration: underline
                      ? TextDecoration.underline
                      : TextDecoration.none,
                  decorationColor: BrandColors.txt300,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: BrandColors.txt300),
          ],
        ),
      ),
    );
  }
}
