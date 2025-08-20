import 'package:go_router/go_router.dart';

import '../screens/customer_service_page.dart';
import '../screens/errorscreen.dart';
import '../screens/auth/findIDPW_page.dart';
import '../screens/auth/login_page.dart';
import '../screens/nickname_page.dart';
import '../screens/auth/signup_page.dart';
import '../screens/spot/scratch_map_page.dart';
import '../widgets/app_initializer.dart'; // 추가

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
      builder: (context, state) =>
          //LoginPage()
          AppInitializer(), // AppInitializer 사용
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      name: 'signup',
      builder: (context, state) => SignUpPage(),
    ),
    GoRoute(
      path: '/nickname',
      name: 'nickname',
      builder: (context, state) => NicknamePage(),
    ),
    GoRoute(
      path: '/find',
      name: 'find',
      builder: (context, state) => FindIDPW(),
    ),
    GoRoute(
      path: '/customer-service',
      name: 'customerService',
      builder: (context, state) => CustomerServicePage(),
    ),
    GoRoute(
      path: '/map',
      name: 'map',
      builder: (context, state) => ScratchMapPage(),
    ),
  ],
);