import 'package:flutter/material.dart';
import 'package:parkourspotkorea/theme/app_colors.dart';

class LocationPermissionDarkPage extends StatelessWidget {
  const LocationPermissionDarkPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: BrandColors.c900,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 이미지와 텍스트 겹치기
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset('assets/images/locationPermission-image.png', width: 280, height: 280,
                        alignment: Alignment.center),

                        // 메인 제목을 이미지 위에 겹치기
                        Positioned(
                          bottom: 40, // 이미지 하단에서 20px 위
                          child: Text(
                            '위치 정보 사용 허용',
                            style: TextStyle(
                              color: BrandColors.txt30,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    // 설명 텍스트
                    Text(
                      '회원님 주변의 파쿠르 장소를 찾아드리기 위해\n위치 정보 사용 권한이 필요해요.',
                      style: TextStyle(
                        color: BrandColors.txt100,
                        fontSize: 14,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16),

                    // 기능 목록
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                      decoration: BoxDecoration(
                        color: BrandColors.c800,
                        borderRadius: BorderRadius.circular(8),
                      ),

                      child: Column(
                        children: [
                          _buildFeatureItem(
                            icon: Icons.person_pin_circle,
                            text: '내 주변 파쿠르 스팟 추천',
                            color: Color(0xFF142033),
                          ),
                          const SizedBox(height: 16),
                          _buildFeatureItem(
                            icon: Icons.compass_calibration,
                            text: '거리 기반 장소 정보 제공',
                            color: Color(0xFF142033),
                          ),
                          const SizedBox(height: 16),
                          _buildFeatureItem(
                            icon: Icons.hexagon,
                            text: '나만의 파쿠르 맵 생성',
                            color: Color(0xFF142033),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16), // 24에서 16으로 줄임

                    // 개인정보 보호 안내
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: BrandColors.c700,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.security,
                            color: BrandColors.c300,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '위치 정보는 안전하게 보호되며,\n언제든지 설정에서 변경할 수 있어요.',
                              style: textTheme.bodySmall?.copyWith(
                                color: BrandColors.c100,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 버튼 영역
              Column(
                children: [
                  // 허용 버튼
                  Container(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        // 위치 정보 허용 로직
                        _handleLocationPermission(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BrandColors.c500,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        '위치 정보 허용',
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: BrandColors.txtWhite,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 나중에 하기 버튼
                  Container(
                    width: double.infinity,
                    height: 52,
                    child: TextButton(
                      onPressed: () {
                        // 나중에 하기 로직
                        _handleLocationPermission(context, false);
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: BrandColors.c600Dark),
                        ),
                      ),
                      child: Text(
                        '나중에 하기',
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: BrandColors.txt300,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: SecondaryColors.c500Default,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: BrandColors.txt30,
            ),
          ),
        ),
      ],
    );
  }

  void _handleLocationPermission(BuildContext context, bool isAllowed) {
    if (isAllowed) {
      // 위치 정보 허용 처리
      print('위치 정보 허용됨');
      // TODO: 실제 위치 권한 요청 및 다음 페이지로 이동
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('위치 정보가 허용되었습니다.'),
          backgroundColor: SecondaryColors.c500Default,
        ),
      );
    } else {
      // 나중에 하기 처리
      print('위치 정보 나중에 하기');
      // TODO: 메인 페이지로 이동하거나 다른 처리
      Navigator.of(context).pop();
    }
  }
}

void main() {
  runApp(
    MaterialApp(
      home: const LocationPermissionDarkPage(),
      theme: ThemeData(fontFamily: 'NotoSans'),
    ),
  );
}
