import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Core
import 'core/app_db.dart';
import 'database/app_database.dart';

// Services
import 'services/drift/drift_map_service.dart';

// Repositories
import 'repositories/user_repository.dart';
import 'repositories/scratch_map_repository.dart';
import 'repositories/location_repository.dart';
import 'repositories/user_repository_wrapper.dart';

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
        // === 1. 기본 데이터베이스 (최하위 계층) ===
        Provider<AppDatabase>.value(value: db),

        // === 2. 기본 서비스들 ===
        Provider<DriftMapService>(
          create: (context) => DriftMapService(context.read<AppDatabase>()),
        ),

        Provider<UserRepository>(
          create: (context) => UserRepository(),
        ),

        // === 3. Repository 구현체들 ===
        Provider<ScratchMapRepository>(
          create: (context) => ScratchMapRepository(
            driftMapService: context.read<DriftMapService>(),
          ),
        ),

        Provider<LocationRepository>(
          create: (context) => LocationRepository(
            userRepository: context.read<UserRepository>(),
          ),
        ),

        // === 4. Repository 인터페이스들 (ViewModel이 사용할 것들) ===
        Provider<IScratchMapRepository>(
          create: (context) => context.read<ScratchMapRepository>(),
        ),

        Provider<ILocationRepository>(
          create: (context) => context.read<LocationRepository>(),
        ),

        Provider<IUserRepository>(
          create: (context) => UserRepositoryWrapper(
            userRepository: context.read<UserRepository>(),
          ),
        ),

        // === 5. ViewModel (오직 Repository 인터페이스만 사용) ===
        ChangeNotifierProvider<ScratchMapViewModel>(
          create: (context) => ScratchMapViewModel(
            scratchMapRepository: context.read<IScratchMapRepository>(),
            userRepository: context.read<IUserRepository>(),
            locationRepository: context.read<ILocationRepository>(),
          ),
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