import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView( // 스크롤 가능하게 만들어주는 위젯
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),

              // 로고 이미지
              Image.asset(
                'assets/logo/parkour_logo.png', // 로고 이미지 경로
                height: 300,
              ),

              const SizedBox(height: 40),

              // 이메일 로그인 텍스트
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '이메일로 로그인',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),

              const SizedBox(height: 10),

              // 이메일 입력창
              TextField(
                decoration: InputDecoration(
                  hintText: '아이디(이메일)을 입력해주세요.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),

              const SizedBox(height: 12),

              // 비밀번호 입력창
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '비밀번호를 입력해주세요.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),

              const SizedBox(height: 24),

              // 로그인 버튼
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFFFF8C00), // 다크 오렌지
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    '로그인',
                    style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold,),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text('또는'),
              const SizedBox(height: 20),

              // 소셜 로그인 (구글 & 애플)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 구글 버튼
                  InkWell(
                    onTap: () {
                      print('구글 로그인 클릭');
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white, // ✅ 배경 흰색
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFE8ECF4), // ✅ 테두리 색
                          width: 1,
                        ),
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/google_ic_loginPage.svg',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),

                  // 애플 버튼
                  InkWell(
                    onTap: () {
                      print('애플 로그인 클릭');
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFE8ECF4),
                          width: 1,
                        ),
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/appleIcon_loginPage.svg',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              // 하단 버튼 3개
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      print("아이디 찾기 클릭됨");
                    },
                    child: const Text(
                      '아이디 찾기',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                  const Text('|', style: TextStyle(color: Colors.black54)),
                  TextButton(
                    onPressed: () {
                      print("비밀번호 재설정 클릭됨");
                    },
                    child: const Text(
                      '비밀번호 재설정',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                  const Text('|', style: TextStyle(color: Colors.black54)),
                  TextButton(
                    onPressed: () { },
                    child: const Text(
                      '회원 가입',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () {},
                child: const Text(
                  '로그인에 어려움이 있나요?',
                  style: TextStyle(color: Colors.black45),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),);
  }
}
