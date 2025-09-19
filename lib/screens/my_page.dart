import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parkourspotkorea/theme/app_colors.dart';

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

  @override
  void initState() {
    super.initState();
    nicknameController = TextEditingController(text: '보라돌이');
    introController = TextEditingController(text: 'hello everyone!');
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

  void _toggleEdit() {
    setState(() {
      isEditing = !isEditing;
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
            icon: Icon(
              Icons.settings,
              color: BrandColors.txt30,
            ),
            onPressed: _showSettingsBottomSheet,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: isEditing
                        ? TextField(
                            controller: nicknameController,
                            style: textTheme.bodyLarge?.copyWith(
                              color: BrandColors.txt30,
                            ),
                            decoration: InputDecoration(
                              hintText: '닉네임 입력',
                              hintStyle: TextStyle(color: BrandColors.txt300),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: StrokeColors.defaultStroke),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: StrokeColors.defaultStroke),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: BrandColors.c500, width: 2),
                              ),
                            ),
                          )
                        : Text(
                            nicknameController.text,
                            style: textTheme.displaySmall?.copyWith(
                              color: BrandColors.txt30,
                              fontSize: 24,
                            ),
                          ),
                  ),
                  IconButton(
                    icon: Icon(
                      isEditing ? Icons.check : Icons.edit,
                      color: BrandColors.c500,
                    ),
                    onPressed: _toggleEdit,
                  ),
                  GestureDetector(
                    onTap: isEditing ? _pickImage : null,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: BrandColors.c700,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : null,
                      child: _profileImage == null
                          ? Icon(Icons.person, size: 40, color: BrandColors.txt300)
                          : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text(
                '내 소개',
                style: textTheme.bodyLarge?.copyWith(
                  color: BrandColors.txt30,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              isEditing
                  ? TextField(
                      controller: introController,
                      maxLines: 4,
                      style: textTheme.bodyLarge?.copyWith(
                        color: BrandColors.txt30,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: BrandColors.c800,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: StrokeColors.defaultStroke),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: StrokeColors.defaultStroke),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: BrandColors.c500, width: 2),
                        ),
                        hintText: '소개를 입력하세요',
                        hintStyle: TextStyle(color: BrandColors.txt300),
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: BrandColors.c800,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: StrokeColors.defaultStroke),
                      ),
                      child: Text(
                        introController.text,
                        style: textTheme.bodyLarge?.copyWith(
                          color: BrandColors.txt100,
                        ),
                      ),
                    ),
              SizedBox(height: 35),
              Row(
                children: [
                  Text(
                    '파쿠르 숙련도 변경',
                    style: textTheme.bodyLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: BrandColors.c500,
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: SecondaryColors.c500Default, width: 2),
                      borderRadius: BorderRadius.circular(5),
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
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: BrandColors.c800,
          borderRadius: BorderRadius.circular(8),
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
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: BrandColors.txt300,
            ),
          ],
        ),
      ),
    );
  }
}
