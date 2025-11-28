import 'package:go_router/go_router.dart';
import 'package:parkourspotkorea/screens/bookmark_page.dart';
import 'package:parkourspotkorea/screens/locationPermission_white_page.dart';
import 'package:parkourspotkorea/screens/location_permission_dark_page.dart';
import 'package:parkourspotkorea/screens/profile/delete_account_page.dart';
import 'package:parkourspotkorea/screens/profile/notice_list_page.dart';

import '../screens/profile/about_creator_page.dart';
import '../screens/auth/signup_page.dart';
import '../screens/customer_service_page.dart';
import '../screens/errorscreen.dart';
import '../screens/auth/reset_password_page.dart';
import '../screens/auth/login_page.dart';
import '../screens/landing_page.dart';
import '../screens/profile/my_page.dart';
import '../screens/nickname_page.dart';
import '../screens/parkourlevel_page.dart';
import '../screens/spot/scratch_map_page.dart';
import '../widgets/app_initializer.dart';
import '../widgets/dialogs/signup_complete_dialog.dart';
import '../widgets/settings_bottom_sheet.dart';

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
      builder:
          (context, state) => //ParkourLandingPage(),
              //SignupCompleteDialog()
              // ParkourLevel()
             // MyPage()
              // NicknamePage(),

          //LoginPage()
              AppInitializer(),
              //Bookmark(),
              //AboutCreatorPage(),
    ),

    // 로그인 페이지
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => LoginPage(),
    ),

    // 회원가입 페이지
    GoRoute(
      path: '/signup',
      name: 'signup',
      builder: (context, state) => const SignUpPage(),
    ),

    // 닉네임 설정 페이지
    GoRoute(
      path: '/nickname',
      name: 'nickname',
      builder: (context, state) => NicknamePage(),
    ),

    // 아이디/비밀번호 찾기
    GoRoute(
      path: '/find',
      name: 'find',
      builder: (context, state) => ResetPasswordPage(),
    ),

    // 고객서비스
    GoRoute(
      path: '/customer-service',
      name: 'customerService',
      builder: (context, state) =>
          CustomerServicePage(from: state.extra as String?),
    ),

    // 지도 페이지
    GoRoute(
      path: '/map',
      name: 'map',
      builder: (context, state) => ScratchMapPage(),
    ),

    // 마이페이지
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => MyPage(),
      routes: [
        // 비밀번호 변경 (profile의 하위 라우트)
        GoRoute(
          path: 'change-password',
          name: 'changePassword',
          builder: (context, state) => ResetPasswordPage(),
        ),
      ],
    ),

    // 파쿠르 레벨 페이지
    GoRoute(
      path: '/parkourLevel',
      name: 'parkourLevel',
      builder: (context, state) => ParkourLevel(),
    ),

    // 나의 파쿠르 스팟 페이지
    GoRoute(
      path: '/spotBookmark',
      name: 'spotBookmark',
      builder: (context, state) => Bookmark(),
    ),

    // 만든이 정보 페이지
    GoRoute(
      path: '/aboutCreator',
      name: 'aboutCreator',
      builder: (context, state) => AboutCreatorPage(),
    ),

    // 공지사항 페이지
    GoRoute(
      path: '/notice',
      name: 'notice',
      builder: (context, state) => NoticeListPage(),
    ),

    // 회원 탈퇴 페이지
    GoRoute(
      path: '/deleteAccount',
      name: 'deleteAccount',
      builder: (context, state) => DeleteAccountPage(),
    ),

    // 로그아웃 페이지
    GoRoute(
      path: '/logout',
      name: 'logout',
      builder: (context, state) => AboutCreatorPage(),
    ),



  ],
);
