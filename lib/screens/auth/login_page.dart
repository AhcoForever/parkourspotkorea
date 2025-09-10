import 'dart:async';
import 'package:provider/provider.dart';
import 'package:parkourspotkorea/repositories/user_repository.dart';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
          .initialize(
        clientId: _getClientId,
        serverClientId: _serverClientId,
      )
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
      await userRepo.ensureUserExists(uid: user.id, email: user.email);
      context.goNamed('map');
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
        await userRepo.ensureUserExists(uid: user.uid, email: user.email ?? 'no-email@unknown');
        // 로그인 성공 시 지도 페이지로 이동
        context.goNamed('map');
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
            spacing: 8,
            children: [
              // 로고 이미지
              Image.asset('assets/logo/PARKOUR_SPOT.png', height: 300),
              //Text('아이디(이메일)', style: Theme.of(context).textTheme.labelSmall),
              // 이메일 입력창
              TextField(
                controller: _emailCtrl,
                decoration: InputDecoration(
                  label: Text('아이디(이메일)을 입력해주세요.'),
                  hintText: 'parkourspot@gmail.com',

                ),

              ),

              // 비밀번호 입력창
              TextField(

                controller: _pwCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  label: Text('비밀번호를 입력해주세요.'),
                  hintText: '비밀번호를 입력해주세요.',
                ),
              ),

              // 로그인 버튼
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
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
                      height: 100,
                      width: 250,

                    ),
                  ),
                ],
              ),

              // 하단 버튼 3개
              Padding(
                padding: const EdgeInsets.only( bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        context.goNamed('find');
                      },
                      child: Text(
                        '비밀번호 찾기',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Color(0xFF6A707C),
                        ),
                      ),
                    ),

                    Text(
                      ' | ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Color(0xFF6A707C),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.goNamed('signup');
                      },
                      child: Text(
                        '회원 가입',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Color(0xFF6A707C),
                        ),
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