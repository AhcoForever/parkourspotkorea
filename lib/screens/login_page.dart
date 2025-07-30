import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:parkourspotkorea/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final _emailCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }

  //로그인 함수
  Future<void> _signin() async {
    //입력 체크
    if (_emailCtrl.text.trim().isEmpty || _pwCtrl.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: '이메일과 비밀번호를 모두 입력해주세요.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      return;
    }
    setState(() => _isLoading = true);
    FocusScope.of(context).unfocus();
    try {
      final user = await _authService.signIn(
        email: _emailCtrl.text.trim(),
        password: _pwCtrl.text.trim(),
      );

      if (user != null) {
        // 로그인 성공 시 지도 페이지로 이동
        context.goNamed('/map');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: '로그인 중 오류가 발생했습니다.:$e',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }

    setState(() => _isLoading = false);
  }

  ///구글 로그인
  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      //var user = await _authService.signInWithGoogle();

      // if (user != null) {
      //   //로그인 성공시 지도 페이지도 이동
      //   context.goNamed('/map');
      // }
    } catch (e) {}

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          // 스크롤 가능하게 만들어주는 위젯
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),

              // 로고 이미지
              Image.asset('assets/logo/parkour_logo.png', height: 300),

              const SizedBox(height: 40),

              // // 이메일 로그인 텍스트
              // const Align(
              //   alignment: Alignment.centerLeft,
              //   child: Text(
              //     '이메일로 로그인',
              //     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              //   ),
              // ),
              const SizedBox(height: 10),

              // 이메일 입력창
              TextField(
                controller: _emailCtrl,
                decoration: InputDecoration(
                  labelText: '이메일',
                  hintText: 'abc@example.com',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),

              const SizedBox(height: 12),

              // 비밀번호 입력창
              TextField(
                controller: _pwCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '비밀번호',
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
                  onPressed: () async {
                    _isLoading ? null : _signin();
                    // await AuthService().signIn(
                    //   email: _emailCtrl.text,
                    //   password: _pwCtrl.text,
                    // );
                    context.goNamed('map');
                  },
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          '로그인 하기',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
                      //_isLoading ? null : _googleSignIn();
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFE8ECF4), //  테두리 색
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
                      context.goNamed('find');
                    },
                    child: const Text(
                      '아이디 / 비밀번호 찾기',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),

                  const Text('|', style: TextStyle(color: Colors.black54)),
                  TextButton(
                    onPressed: () {
                      context.goNamed('signup');
                    },
                    child: const Text(
                      '회원 가입',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  context.goNamed('customerService');
                },
                child: const Text(
                  '로그인에 어려움이 있나요?',
                  style: TextStyle(color: Colors.black45),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}


