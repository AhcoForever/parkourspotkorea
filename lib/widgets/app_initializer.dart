import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parkourspotkorea/screens/auth/login_page.dart';
import 'package:parkourspotkorea/screens/spot/map_page.dart';

import '../screens/spot/scratch_map_page.dart';

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  _AppInitializerState createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  /// 앱 시작 시 사용자 로그인 상태 확인
  Future<void> _checkUserStatus() async {
    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      setState(() {
        _isLoggedIn = user != null;
      });
    } catch (e) {
      debugPrint('사용자 상태 확인 오류: $e');
      setState(() {
        _isLoggedIn = false;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
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

    // 로그인 상태에 따라 MapPage (로그인 성공) 또는 LoginPage (로그인 필요) 분기
    return _isLoggedIn ?  ScratchMapPage() : const LoginPage();
  }
}