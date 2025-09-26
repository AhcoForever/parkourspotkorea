import 'package:flutter/material.dart';
import 'package:parkourspotkorea/theme/app_colors.dart';
import 'package:parkourspotkorea/widgets/comfirm_button.dart';
import 'package:parkourspotkorea/widgets/dialogs/signup_complete_dialog.dart';
import 'package:go_router/go_router.dart';

/// 파쿠르 레벨 선택 화면
class ParkourLevel extends StatefulWidget {
  // 상수 정의
  static const double _viewportFraction = 0.85;
  static const double _cardBorderRadius = 5.0;
  static const double _activeBorderWidth = 3.0;
  static const double _activeScale = 1.0;
  static const double _inactiveScale = 0.9;
  static const int _scaleAnimationDuration = 200;
  static const int _indicatorAnimationDuration = 300;
  static const double _indicatorActiveWidth = 24.0;
  static const double _indicatorInactiveWidth = 8.0;
  static const double _indicatorHeight = 8.0;
  final String? nickname;

  const ParkourLevel({Key? key, this.nickname}) : super(key: key);

  @override
  _ParkourLevelState createState() => _ParkourLevelState();
}

class _ParkourLevelState extends State<ParkourLevel> {
  late PageController _pageController;

  final List<_LevelInfo> _levels = [
    _LevelInfo(imagePath: 'assets/images/cardTraceur-2.png', levelType: '초급'),
    _LevelInfo(imagePath: 'assets/images/cardFreerunner.png', levelType: '중급'),
    _LevelInfo(imagePath: 'assets/images/cardYamak.png', levelType: '고급'),
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: ParkourLevel._viewportFraction, initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.c800,
      appBar: AppBar(
        title: Text(
          '파쿠르 레벨 선택',
          style: Theme.of(
            context,
          ).appBarTheme.titleTextStyle?.copyWith(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          padding: const EdgeInsets.only(left: 20),
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.goNamed('nickname');
          },
        ),
        backgroundColor: BrandColors.c800,
        centerTitle: true,
        foregroundColor: BrandColors.c50,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 제목 텍스트
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 14,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '카드를 넘겨, 당신의\n파쿠르 숙련도를 선택해주세요!',
                  style: TextStyle(
                    color: BrandColors.txt30,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),

            // 카드 뷰
            Expanded(
              flex: 1,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _levels.length,
                onPageChanged: _onPageChanged,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final level = _levels[index];
                  final isActive = _currentIndex == index;

                  // 간단한 스케일 계산
                  final scale = isActive ? ParkourLevel._activeScale : ParkourLevel._inactiveScale;

                  return AnimatedScale(
                    scale: scale,
                    duration: Duration(milliseconds: ParkourLevel._scaleAnimationDuration),
                    child: Container(
                      margin: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(ParkourLevel._cardBorderRadius),
                        border: Border.all(
                          color: isActive
                              ? SecondaryColors.c500Default
                              : Colors.transparent,
                          width: ParkourLevel._activeBorderWidth,
                        ),
                        image: level.imagePath.isNotEmpty
                            ? DecorationImage(
                                image: AssetImage(level.imagePath),
                                fit: BoxFit.fitWidth,
                                onError: (exception, stackTrace) {
                                  print('Image load error: $exception');
                                },
                              )
                            : null,
                        color: level.imagePath.isEmpty ? BrandColors.c700 : null,
                      ),
                      child: level.imagePath.isEmpty
                          ? Icon(
                              Icons.sports_gymnastics,
                              size: 80,
                              color: BrandColors.txt300,
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),

            // 하단 고정 영역
            Column(
              children: [
                // 페이지 인디케이터
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _levels.length,
                      (index) => AnimatedContainer(
                        duration: Duration(milliseconds: ParkourLevel._indicatorAnimationDuration),
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        width: _currentIndex == index ? ParkourLevel._indicatorActiveWidth : ParkourLevel._indicatorInactiveWidth,
                        height: ParkourLevel._indicatorHeight,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? BrandColors.c500
                              : BrandColors.c600Dark,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),

                // 안내 텍스트
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '* 현재 고른 레벨은 추후 변경이 가능합니다. 마이페이지-파쿠르 숙련도 변경',
                    style: TextStyle(
                      color: BrandColors.txt500,
                      fontSize: 11,
                      height: 1.27,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 12),

                // 시작하기 버튼
                ComfirmButton(
                  text: '시작하기',
                  onPressed: () {
                    final selected = _levels[_currentIndex].levelType;
                    print('선택된 레벨: $selected');
                    SignupCompleteDialog.show(
                      context,
                      () {
                        context.goNamed('map');
                      },
                      title: '프로필 설정 완료',
                      message: '이제 주변의 파쿠르 스팟을\n찾으러 떠나볼까요?',
                    );
                  },
                ),
                SizedBox(height: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelInfo {
  final String imagePath;
  final String levelType;

  _LevelInfo({required this.imagePath, required this.levelType});
}
