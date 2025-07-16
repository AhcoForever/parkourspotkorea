import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parkourspotkorea/routes/app_router.dart';
import 'package:parkourspotkorea/screens/account_setting_page.dart';
import 'package:parkourspotkorea/screens/addedbookmark_page.dart';
import 'package:parkourspotkorea/screens/bookmark_page.dart';
import 'package:parkourspotkorea/screens/customer_service_page.dart';
import 'package:parkourspotkorea/screens/findIDPW_page.dart';
import 'package:parkourspotkorea/screens/login_page.dart';
import 'package:parkourspotkorea/screens/map_page.dart';
import 'package:parkourspotkorea/screens/mapsearch_page.dart';
import 'package:parkourspotkorea/screens/meetup_page.dart';
import 'package:parkourspotkorea/screens/nickname_page.dart';
import 'package:parkourspotkorea/screens/locationPermission_Page.dart';
import 'package:parkourspotkorea/screens/parkourlevel_page.dart';
import 'package:parkourspotkorea/screens/profile_page.dart';
import 'package:parkourspotkorea/screens/signup_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
   const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      title: 'Parkour Spot',

      //home: MapScreen(),
      //장소 검색시 공통된 키워드를 갖고 있는 장소가 핀으로 나타남, bottom sheet로 장소 리스트가 나타남.
      //home: LocationPermissionPage(),
      //home: ParkourLevel(),
      //home: AddedNewSpot(),
      //home: Bookmark(),
      //home: MapSearchDetailPage(),
      //home: AccountSettingsPage(),
      //home: ProfilePage(),
      //home: NicknamePage(),
      //home: BasicMapPage(),
      //home: FindIDPW(),
      //home: CustomerServicePage(),
      //home: SignUpPage(),
      //home: SignupCompleteDialog(),
      //home: const LoginPage()
    );
  }
}

