import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkourspotkorea/repositories/user_repository.dart';
import 'package:parkourspotkorea/routes/app_router.dart';
import 'package:parkourspotkorea/theme/app_theme.dart';
import 'package:provider/provider.dart';

import 'database/app_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //firebase 초기화
  await Firebase.initializeApp();

  //세로 모드 고정
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //상태바 스타일 설정
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  final db = AppDatabase();
  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: db),
        Provider<UserRepository>(create: (_) => UserRepository(db)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      title: 'Parkour Spot in Korea',
      theme: AppTheme.light,
    );
  }
}