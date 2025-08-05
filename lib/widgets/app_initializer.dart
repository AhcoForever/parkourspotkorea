import 'package:flutter/material.dart';
import 'package:parkourspotkorea/screens/auth/login_page.dart';
import 'package:parkourspotkorea/screens/spot/map_page.dart';
import '../services/auth_service.dart';


class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  _AppInitializerState createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkUserStatus(); // 앱 시작 시 사용자 상태 확인
  }

  /// 앱 시작 시 사용자 로그인 상태 확인
  Future<void> _checkUserStatus() async {
    try {
      // 1. Firebase Auth 상태 확인 & 로컬 DB 동기화
      await _authService.checkUserOnAppStart();

      // 2. 로그인 여부 확인
      bool loggedIn = _authService.currentFirebaseUser != null;

      setState(() {
        _isLoggedIn = loggedIn;
        _isLoading = false;
      });

    } catch (e) {
      print('사용자 상태 확인 오류: $e');
      setState(() {
        _isLoading = false;
        _isLoggedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('앱을 시작하는 중...'),
            ],
          ),
        ),
      );
    }

    // 로그인 상태에 따라 화면 분기
    return _isLoggedIn ? LoginPage() : MapPage();
  }
}