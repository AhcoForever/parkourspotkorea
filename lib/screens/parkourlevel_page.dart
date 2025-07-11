import 'package:flutter/material.dart';

/// 파쿠르 레벨 선택 화면
/// assets/images/beginner.png, intermediate.png, advanced.png 이미지를 준비하고
/// pubspec.yaml assets 섹션에 등록하세요.
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
      backgroundColor: Color(0xFFFFF5E0),
    ),
    _LevelInfo(
      title: '중급',
      imagePath: 'assets/images/intermediate.png',
      backgroundColor: Color(0xFFFFE0B2),
    ),
    _LevelInfo(
      title: '고급',
      imagePath: 'assets/images/advanced.png',
      backgroundColor: Color(0xFFFFB74D),
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
              color: Colors.white,
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
                          color: Colors.blue,
                        ),
                      ),
                      TextSpan(
                        text: '님,\n환영합니다!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
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
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      '확인',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '나의 파쿠르 레벨은?',
          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
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
                          color: isSelected ? Colors.orange : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
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
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.image,
                                      size: 48,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            level.title,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
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
                backgroundColor: Colors.orange,
                disabledForegroundColor: Colors.orange.shade200.withOpacity(0.38),
                disabledBackgroundColor: Colors.orange.shade200.withOpacity(0.12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: Text(
                '선택 완료',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white
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

// 사용 예시
void main() {
  runApp(MaterialApp(
    home: ParkourLevel(nickname: "보라돌이"), // 닉네임 전달
    theme: ThemeData(
      fontFamily: 'NotoSans',
    ),
  ));
}