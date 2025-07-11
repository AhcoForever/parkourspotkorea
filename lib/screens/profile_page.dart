import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('내 프로필'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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
                            decoration: InputDecoration(
                              hintText: '닉네임 입력',
                              border: UnderlineInputBorder(),
                            ),
                          )
                        : Text(
                            nicknameController.text,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  IconButton(
                    icon: Icon(isEditing ? Icons.check : Icons.edit),
                    onPressed: _toggleEdit,
                  ),
                  GestureDetector(
                    onTap: isEditing ? _pickImage : null,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : null,
                      child: _profileImage == null
                          ? Icon(Icons.person, size: 40, color: Colors.grey)
                          : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text(
                '내 소개',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              isEditing
                  ? TextField(
                      controller: introController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: '소개를 입력하세요',
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(introController.text),
                    ),
              SizedBox(height: 35),
              Row(
                children: [
                  Text(

                    '파쿠르 실력',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.blueAccent,

                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text('초급', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w700, fontSize: 12)),
                  ),
                  Spacer(),
                  Icon(Icons.info_outline, color: Colors.grey),
                ],
              ),
              SizedBox(height: 16),
              _buildMenuItem('계정 설정', () {}),
              _buildMenuItem('공지사항', () {}),
              _buildMenuItem('친구 초대', () {}),
              _buildMenuItem('고객 지원', () {}),
              _buildMenuItem('언어 설정', () {}),
              _buildMenuItem('버전 1.0.0.', () {}),
              _buildMenuItem('로그아웃', () {
                // 로그아웃 로직
              }, underline: true),
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
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(15),
        child: Row(
          children: [

            Expanded(
              child: Text(

                title,
                style: TextStyle(
                  decoration: underline
                      ? TextDecoration.underline
                      : TextDecoration.none,

                ),
              ),
            ),

            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
