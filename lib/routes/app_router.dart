// lib/routes/app_router.dart (간소화된 버전)

import 'package:go_router/go_router.dart';

import '../screens/auth/signup_page.dart';
import '../screens/customer_service_page.dart';
import '../screens/errorscreen.dart';
import '../screens/auth/find_password_page.dart';
import '../screens/auth/login_page.dart';
import '../screens/landing_page.dart';
import '../screens/nickname_page.dart';
import '../screens/spot/scratch_map_page.dart';
import '../widgets/app_initializer.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) {
    return Errorscreen(message: state.error.toString());
  },
  routes: [
    // 앱 시작 시 로그인 상태 체크
    GoRoute(
      path: '/',
      name: 'initializer',
      builder: (context, state) =>  //ParkourLandingPage(),

      //NicknamePage(),
      //LoginPage()
     AppInitializer(),
    ),

    // 로그인 페이지
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => LoginPage(),
    ),

    // 회원가입 페이지 (이제 Provider가 main.dart에서 전역으로 제공됨)
    GoRoute(
      path: '/signup',
      name: 'signup',
      builder: (context, state) => const SignUpPage(),
    ),

    // 닉네임 설정 페이지
    GoRoute(
      path: '/nickname',
      name: 'nickname',
      builder: (context, state) =>  NicknamePage(),
    ),

    // 아이디/비밀번호 찾기
    GoRoute(
      path: '/find',
      name: 'find',
      builder: (context, state) => FindIDPW(),
    ),

    // 고객서비스
    GoRoute(
      path: '/customer-service',
      name: 'customerService',
      builder: (context, state) => CustomerServicePage(),
    ),

    // 지도 페이지
    GoRoute(
      path: '/map',
      name: 'map',
      builder: (context, state) => ScratchMapPage(),
    ),
  ],
);