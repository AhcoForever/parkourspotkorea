import 'dart:async';
import 'package:parkourspotkorea/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:parkourspotkorea/repositories/user_repository.dart';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../services/firebase/auth_service.dart';

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
  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false;
  String _contactText = '';
  String _errorMessage = '';
  String _serverAuthCode = '';

  String? _error;
  List<String> scopes = <String>['email', 'profile'];

  // 플랫폼별 클라이언트 ID 설정
  String get _getClientId {
    if (Platform.isAndroid) {
      return '1095125086960-v0vqn08vt4c89p2viul7rg909l19hcej.apps.googleusercontent.com'; // Android용 클라이언트 ID
    } else if (Platform.isIOS) {
      return '1095125086960-9pp9lm12f4ktbslqgeim7g8t8ksgmam3.apps.googleusercontent.com'; // iOS용 클라이언트 ID
    } else {
      throw UnsupportedError('지원되지 않는 플랫폼입니다.');
    }
  }

  static const String _serverClientId =
      '1095125086960-o6km1nffgub8gh2na1h1fdope3rdihrh.apps.googleusercontent.com';

  @override
  void initState() {
    super.initState();
    googleSignin();
  }

  void googleSignin() {
    final GoogleSignIn signIn = GoogleSignIn.instance;
    unawaited(
      signIn
          .initialize(clientId: _getClientId, serverClientId: _serverClientId)
          .then((_) {
            signIn.authenticationEvents
                .listen(_handleAuthenticationEvent)
                .onError(_handleAuthenticationError);
          }),
    );
  }

  Future<void> _handleAuthenticationError(Object e) async {
    Fluttertoast.showToast(
      msg: '로그인 중 오류가 발생했습니다.:$e',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  Future<void> _handleAuthenticationEvent(
    GoogleSignInAuthenticationEvent event,
  ) async {
    // #docregion CheckAuthorization
    final GoogleSignInAccount? user = // ...
        // #enddocregion CheckAuthorization
        switch (event) {
          GoogleSignInAuthenticationEventSignIn() => event.user,
          GoogleSignInAuthenticationEventSignOut() => null,
        };

    // Check for existing authorization.
    // #docregion CheckAuthorization
    final GoogleSignInClientAuthorization? authorization = await user
        ?.authorizationClient
        .authorizationForScopes(scopes);
    // #enddocregion CheckAuthorization

    setState(() {
      _currentUser = user;
      _isAuthorized = authorization != null;
      _errorMessage = '';
    });

    // If the user has already granted access to the required scopes, call the
    // REST API.
    if (user != null && authorization != null) {
      // 구글 로그인 성공 시 로컬 사용자 생성/동기화
      final userRepo = context.read<UserRepository>();
      final isFirstTime = await userRepo.ensureUserExists(uid: user.id, email: user.email);

      // 최초 로그인 사용자는 닉네임 페이지로, 기존 사용자는 지도 페이지로 이동
      if (isFirstTime) {
        context.goNamed('nickname');
      } else {
        context.goNamed('map');
      }
    }
  }

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
        // 로그인 성공 시 로컬 사용자 생성/동기화
        final userRepo = context.read<UserRepository>();
        final isFirstTime = await userRepo.ensureUserExists(
          uid: user.uid,
          email: user.email ?? 'no-email@unknown',
        );

        // 최초 로그인 사용자는 닉네임 페이지로, 기존 사용자는 지도 페이지로 이동
        if (isFirstTime) {
          context.goNamed('nickname');
        } else {
          context.goNamed('map');
        }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 로고 이미지
              SvgPicture.asset(
                'assets/logo/login-parkourspot.svg',
                height: 260,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
              // 이메일 입력창
              TextField(
                controller: _emailCtrl,
                style: TextStyle(color: BrandColors.txt30),
                decoration: InputDecoration(
                  label: Text('아이디(이메일)을 입력해주세요.'),
                  hintText: 'parkourspot@gmail.com',
                ),
              ),

              SizedBox(height: 16),

              // 비밀번호 입력창
              TextField(
                controller: _pwCtrl,
                style: TextStyle(color: BrandColors.txt30),
                obscureText: true,
                decoration: InputDecoration(
                  label: Text('비밀번호를 입력해주세요.'),
                  hintText: '영문+숫자+특수문자 조합 8~16자리',
                ),
              ),

              // 로그인 버튼
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(),
                    onPressed: _isLoading ? null : _signin,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : Text('로그인'),
                  ),
                ),
              ),
              SizedBox(height: 50),
              // 소셜 로그인 (구글)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 구글 버튼
                  InkWell(
                    onTap: () {
                      GoogleSignIn.instance.authenticate();
                    },
                    child: Image.asset(
                      'assets/images/ios_dark_rd_ctn@3x.png',
                      height: 49,
                      width: 221,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              // 하단 버튼 3개
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        context.goNamed('find');
                      },
                      child: Text(
                        '비밀번호 재설정',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: BrandColors.txt30,
                          fontWeight: FontWeight.w600,

                          fontSize: 12,
                        ),
                      ),
                    ),

                    Text(
                      '  |  ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: BrandColors.txt30,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.goNamed('signup');
                      },
                      child: Text(
                        '회원 가입',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: BrandColors.txt30,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextButton(
                  onPressed: () {
                    context.pushNamed('customerService', extra: 'login');
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: BrandColors.txt300,

                        ),
                      ),
                    ),
                    child: Text(
                      '로그인에 어려움이 있나요?',
                      style: TextStyle(color: BrandColors.txt300, fontSize: 12, fontFamily: 'Pretendard'),
                    ),
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
