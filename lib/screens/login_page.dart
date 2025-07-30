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
      // var user = await _authService.signInWithGoogle();

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
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 로고 이미지
              Image.asset('assets/logo/parkour_logo.png', height: 300),

              // 이메일 입력창
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextField(
                  controller: _emailCtrl,
                  decoration: InputDecoration(
                    label: Align(
                      alignment: Alignment.center,
                      child: Text('아이디(이메일)을 입력해주세요.'),
                    ),
                    hintText: 'parkourspot@gmail.com',
                  ),
                ),
              ),

              // 비밀번호 입력창
              TextField(
                controller: _pwCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  label: Align(
                    alignment: Alignment.center,
                    child: Text('비밀번호를 입력해주세요.'),
                  ),
                  hintText: '비밀번호를 입력해주세요.',
                ),
              ),



              // 로그인 버튼
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(),
                    onPressed: () async {
                      _isLoading ? null : _signin();
                      await AuthService().signIn(
                        email: _emailCtrl.text,
                        password: _pwCtrl.text,
                      );
                      context.goNamed('map');
                    },
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : Text('로그인'),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 20.0, top: 25.0),
                child: Text(
                  '다른 방법으로 로그인',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Color(0xFF6A707C)),
                ),
              ),

              // 소셜 로그인 (구글 & 애플)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 구글 버튼
                  InkWell(
                    onTap: () {
                      //_isLoading ? null : googleSignIn();
                    },
                    borderRadius: BorderRadius.circular(12),
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
                  const SizedBox(width: 50),


                  // ClipOval(
                  //
                  //   child: Container(
                  //     width: 200,
                  //     height: 100,
                  //     color: Colors.blue,
                  //     child: Container(
                  //       padding: EdgeInsets.all(12),
                  //
                  //     ),
                  //   ),
                  // ),

                  // 애플 버튼
                  InkWell(
                    onTap: () {
                      print('애플 로그인 클릭');
                    },
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

              // 하단 버튼 3개
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        context.goNamed('find');
                      },
                      child:  Text(
                        '아이디 / 비밀번호 찾기',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Color(0xFF6A707C)),
                      ),
                    ),

                    Text(
                      ' | ',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Color(0xFF6A707C)),
                    ),
                    TextButton(
                      onPressed: () {
                        context.goNamed('signup');
                      },
                      child: Text(
                        '회원 가입',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Color(0xFF6A707C)),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: TextButton(
                  onPressed: () {
                    context.goNamed('customerService');
                  },
                  child: Text(
                    '로그인에 어려움이 있나요?',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
