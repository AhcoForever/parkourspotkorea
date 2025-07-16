import 'package:go_router/go_router.dart';

import '../screens/customer_service_page.dart';
import '../screens/findIDPW_page.dart';
import '../screens/map_page.dart';
import '../screens/login_page.dart';
import '../screens/nickname_page.dart';
import '../screens/signup_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'login',
      builder: (context, state) => const LoginPage(),
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
      builder: (context, state) =>  FindIDPW(),
    ),
    GoRoute(
      path: '/customer-service',
      name: 'customerService',
      builder: (context, state) => CustomerServicePage(),
    ),
    GoRoute(
      path: '/map',
      name: 'map',
      builder: (context, state) => MapPage(),
    ),
  ],
);
