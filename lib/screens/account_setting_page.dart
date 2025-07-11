import 'package:flutter/material.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 상단 앱바
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        // '<' 버튼
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '계정 설정',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextButton(
                text: '비밀번호 변경',
                onTap: () {
                  // TODO: 비밀번호 변경 로직
                },
              ),
              SizedBox(height: 16),
              _buildTextButton(
                text: '회원탈퇴',
                onTap: () {
                  // TODO: 회원탈퇴 로직
                },
              ),
              Spacer(),
              // 우측 하단의 '...' 아이콘
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.more_horiz,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          decoration: TextDecoration.underline,
          color: Colors.black,
        ),
      ),
    );
  }
}
