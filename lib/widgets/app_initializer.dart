import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../repositories/user_repository.dart';

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  _AppInitializerState createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  /// 앱 초기화 및 로그인 상태 확인
  Future<void> _initializeApp() async {
    try {
      // Firebase Auth 상태 체크
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // 로그인된 사용자가 있는 경우
        print('✅ 기존 로그인 사용자 확인: ${user.email}');

        // 로컬 DB에 사용자 정보 동기화
        final userRepo = context.read<UserRepository>();
        await userRepo.ensureUserExists(
            uid: user.uid,
            email: user.email ?? 'no-email@unknown'
        );

        // 약간의 지연 후 지도 페이지로 이동
        await Future.delayed(const Duration(milliseconds: 500));

        if (mounted) {
          context.go('/map');
        }
      } else {
        // 로그인된 사용자가 없는 경우
        print('❌ 로그인된 사용자 없음');

        // 약간의 지연 후 로그인 페이지로 이동
        await Future.delayed(const Duration(milliseconds: 500));

        if (mounted) {
          context.go('/login');
        }
      }
    } catch (e) {
      print('❌ 앱 초기화 오류: $e');

      // 오류 발생 시 로그인 페이지로 이동
      if (mounted) {
        context.go('/login');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 앱 로고
            Image.asset(
              'assets/logo/parkour_logo.png',
              height: 120,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.image,
                    size: 48,
                    color: Colors.grey,
                  ),
                );
              },
            ),
            const SizedBox(height: 40),

            // 로딩 인디케이터
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3A59D1)),
            ),
            const SizedBox(height: 24),

            // 로딩 텍스트
            const Text(
              '앱을 시작하는 중...',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF6A707C),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}