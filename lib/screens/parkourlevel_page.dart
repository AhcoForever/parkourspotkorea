import 'package:flutter/material.dart';
import 'package:parkourspotkorea/theme/app_colors.dart';

/// 파쿠르 레벨 선택 화면
class ParkourLevel extends StatefulWidget {
  final String? nickname; // 닉네임을 받는 매개변수 추가

  const ParkourLevel({Key? key, this.nickname}) : super(key: key);

  @override
  _ParkourLevelState createState() => _ParkourLevelState();
}

class _ParkourLevelState extends State<ParkourLevel> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  final List<_LevelInfo> _levels = [
    _LevelInfo(
      title: '초급',
      imagePath: 'assets/images/beginner.png',
      backgroundColor: BrandColors.c700,
    ),
    _LevelInfo(
      title: '중급',
      imagePath: 'assets/images/intermediate.png',
      backgroundColor: BrandColors.c600Dark,
    ),
    _LevelInfo(
      title: '고급',
      imagePath: 'assets/images/advanced.png',
      backgroundColor: BrandColors.c500,
    ),
  ];

  int? _selectedIndex;

  void _showWelcomeDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: BrandColors.c800,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 16),
                // 환영 메시지
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${widget.nickname ?? "사용자"}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: BrandColors.c500,
                        ),
                      ),
                      TextSpan(
                        text: '님,\n환영합니다!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: BrandColors.txt30,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                // 확인 버튼
                Container(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // TODO: 다음 페이지로 이동하는 로직 구현
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BrandColors.c500,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      '확인',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: BrandColors.txtWhite,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: BrandColors.c800,
      appBar: AppBar(
        title: Text(
          '파쿠르 레벨 선택',
          style: Theme.of(
            context,
          ).appBarTheme.titleTextStyle?.copyWith(fontWeight: FontWeight.w600),
        ),
        backgroundColor: BrandColors.c800,
        centerTitle: true,
        foregroundColor: BrandColors.c50,
      ),

      body: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Text(
                '카드를 넘겨, 당신의 \n파쿠르 숙련도를 선택해주세요!',
                style: TextStyle(
                  color: BrandColors.txt30,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _levels.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final level = _levels[index];
                final isSelected = _selectedIndex == index;
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 40, horizontal: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: level.backgroundColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? BrandColors.c500
                              : BrandColors.c600Dark,
                          width: isSelected ? 3 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Image.asset(
                                level.imagePath,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  // 이미지 로드 실패 시 플레이스홀더
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: BrandColors.c700,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.image,
                                      size: 48,
                                      color: BrandColors.txt300,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            level.title,
                            style: textTheme.headlineMedium?.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: BrandColors.txtWhite,
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _selectedIndex != null
                  ? () {
                      final selected = _levels[_selectedIndex!].title;
                      // 환영 다이얼로그 표시
                      _showWelcomeDialog();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: BrandColors.c500,
                disabledForegroundColor: BrandColors.c600Dark.withOpacity(0.38),
                disabledBackgroundColor: BrandColors.c600Dark.withOpacity(0.12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
              child: Text(
                '선택 완료',
                style: textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: BrandColors.txtWhite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelInfo {
  final String title;
  final String imagePath;
  final Color backgroundColor;

  _LevelInfo({
    required this.title,
    required this.imagePath,
    required this.backgroundColor,
  });
}
