import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkourspotkorea/services/scratch_map_service.dart';
import 'package:provider/provider.dart';

// Core
import 'core/app_db.dart';
import 'database/app_database.dart';

// Services
import 'services/drift/drift_map_service.dart';

// Repositories
import 'repositories/user_repository.dart';
import 'repositories/scratch_map_repository.dart';

// Interfaces
import 'interfaces/scratch_map_interfaces.dart';

// ViewModels
import 'viewmodel/scratch_map_viewmodel.dart';

// Theme & Routes
import 'theme/app_theme.dart';
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화
  await Firebase.initializeApp();

  // 세로 모드 고정
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // 상태바 스타일 설정
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  final db = AppDB.instance;

  runApp(
    MultiProvider(
      providers: [
        // 1. 가장 하위 서비스들 (의존성 없는 것들)
        Provider<AppDatabase>.value(value: db),

        Provider<DriftMapService>(
          create: (context) => DriftMapService(db),
        ),

        Provider<UserRepository>(
          create: (context) => UserRepository(),
        ),

        // 2. 인터페이스 구현체들 등록
        Provider<ILocationService>(
          create: (context) => ScratchMapService(),
        ),

        Provider<IHexagonService>(
          create: (context) => HexagonService(),
        ),

        // 3. Repository들 등록
        ProxyProvider<DriftMapService, IScratchMapRepository>(
          update: (context, driftMapService, _) =>
              ScratchMapRepository(driftMapService: driftMapService),
        ),

        ProxyProvider<UserRepository, IUserRepository>(
          update: (context, userRepository, _) =>
              ScratchMapUserRepository(userRepository: userRepository),
        ),

        // 4. ViewModel 등록
        ProxyProvider4<IScratchMapRepository, ILocationService, IUserRepository, IHexagonService, ScratchMapViewModel>(
          update: (
              context,
              scratchMapRepository,
              locationService,
              userRepository,
              hexagonService,
              _
              ) {
            return ScratchMapViewModel(
              scratchMapRepository: scratchMapRepository,
              locationService: locationService,
              userRepository: userRepository,
              hexagonService: hexagonService,
            );
          },
          dispose: (context, viewModel) => viewModel.dispose(),
        ),
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