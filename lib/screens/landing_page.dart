import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parkour Landing',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: ParkourLandingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ParkourLandingPage extends StatefulWidget {
  const ParkourLandingPage({super.key});

  @override
  _ParkourLandingPageState createState() => _ParkourLandingPageState();
}

class _ParkourLandingPageState extends State<ParkourLandingPage>
    with TickerProviderStateMixin {
  // 비디오 컨트롤러
  VideoPlayerController? _videoController;

  // 텍스트 애니메이션 관련
  String appName = "PARKOUR";
  List<AnimationController> letterControllers = [];
  List<Animation<double>> opacityAnimations = [];

  // 상태 관리
  bool isVideoFinished = false;
  bool showTextAnimation = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
    _initTextAnimations();
  }

  // 비디오 초기화
  void _initVideo() async {
    try {
      _videoController = VideoPlayerController.asset(
        'assets/videos/testvideo.mp4',
        // 또는 네트워크 비디오: VideoPlayerController.network('https://...');

      );

      await _videoController!.initialize();

      // 비디오 완료 리스너 등록
      _videoController!.addListener(_videoListener);

      // 비디오 자동 재생
      _videoController!.play();
    } catch (e) {
      print('비디오 로드 오류: $e');
      // 비디오 로드 실패시 바로 텍스트 애니메이션 시작
      _startTextAnimation();
    }
  }

  // 비디오 상태 감지
  void _videoListener() {
    if (_videoController != null) {
      // 비디오가 끝까지 재생되었는지 확인
      if (_videoController!.value.position >=
          _videoController!.value.duration) {
        if (!isVideoFinished) {
          setState(() {
            isVideoFinished = true;
          });
          _startTextAnimation();
        }
      }
    }
  }

  // 텍스트 애니메이션 초기화
  void _initTextAnimations() {
    letterControllers = List.generate(
      appName.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 800), // 각 글자 페이드인 시간
        vsync: this,
      ),
    );

    // 투명도 애니메이션 (0.0 → 1.0)
    opacityAnimations = letterControllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    }).toList();
  }

  // 텍스트 애니메이션 시작
  void _startTextAnimation() async {
    setState(() {
      showTextAnimation = true;
    });

    // 각 글자마다 순차적으로 나타나게 하기
    for (int i = 0; i < letterControllers.length; i++) {
      await Future.delayed(Duration(milliseconds: 200)); // 글자 간 간격
      if (mounted) {
        letterControllers[i].forward();
      }
    }

    // 모든 글자 애니메이션 완료 후 추가 효과
    await Future.delayed(Duration(milliseconds: 1000));
    if (mounted) {
      _showFinalContent();
    }
  }

  // 최종 콘텐츠 표시
  void _showFinalContent() {
    // 여기서 시작 버튼이나 추가 UI 표시
    print("텍스트 애니메이션 완료! 다음 단계로...");
  }

  // 비디오 다시 재생 (테스트용)
  void _replayVideo() {
    if (_videoController != null) {
      setState(() {
        isVideoFinished = false;
        showTextAnimation = false;
      });

      // 애니메이션 리셋
      for (var controller in letterControllers) {
        controller.reset();
      }

      // 비디오 다시 재생
      _videoController!.seekTo(Duration.zero);
      _videoController!.play();
    }
  }

  @override
  void dispose() {
    _videoController?.removeListener(_videoListener);
    _videoController?.dispose();
    for (var controller in letterControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 비디오 레이어
          if (!isVideoFinished)
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController!.value.size.width,
                  height: _videoController!.value.size.height,
                  child: VideoPlayer(_videoController!),
                ),
              ),
            ),

          // 텍스트 애니메이션 레이어
          if (showTextAnimation)
            Positioned.fill(
              child: Container(
                // 반투명 오버레이로 텍스트 가독성 높이기
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.3),
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // PARKOUR 텍스트
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(appName.length, (index) {
                          return AnimatedBuilder(
                            animation: opacityAnimations[index],
                            builder: (context, child) {
                              return Opacity(
                                opacity: opacityAnimations[index].value,
                                child: Text(
                                  appName[index],
                                  style: TextStyle(
                                    fontSize: 56,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                    letterSpacing: 4.0,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 20.0,
                                        color: Colors.orange.withValues(
                                          alpha: 0.5,
                                        ),
                                        offset: Offset(0, 0),
                                      ),
                                      Shadow(
                                        blurRadius: 40.0,
                                        color: Colors.black,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // 테스트용 재생 버튼 (개발 중에만 사용)
          if (isVideoFinished)
            Positioned(
              top: 50,
              right: 20,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.orange,
                onPressed: _replayVideo,
                child: Icon(Icons.replay, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
