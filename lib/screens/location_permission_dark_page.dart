import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parkourspotkorea/theme/app_colors.dart';
import 'package:parkourspotkorea/widgets/comfirm_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

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
                        Image.asset('assets/images/locationPermission-image.png', width: 400, height: 280,
                        alignment: Alignment.center),

                        // 메인 제목을 이미지 위에 겹치기
                        Positioned(
                          bottom: 60, // 이미지 하단에서 20px 위
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
                    Transform.translate(
                      offset: Offset(0, -40), // 위로 40px 이동
                      child: Text(
                      '회원님 주변의 파쿠르 장소를 찾아드리기 위해\n위치 정보 사용 권한이 필요해요.',
                      style: TextStyle(
                        color: BrandColors.txt100,
                        fontSize: 14,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                      ),
                    ),


                    // 기능 목록
                    Transform.translate(
                      offset: Offset(0, -20), // 위로 20px 이동
                      child: Container(
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
                          const SizedBox(height: 24),
                          _buildFeatureItem(
                            icon: Icons.compass_calibration,
                            text: '거리 기반 장소 정보 제공',
                            color: Color(0xFF142033),
                          ),
                          const SizedBox(height: 24),
                          _buildFeatureItem(
                            icon: Icons.hexagon,
                            text: '나만의 파쿠르 맵 생성',
                            color: Color(0xFF142033),
                          ),
                        ],
                      ),
                      ),
                    ),


                    // 개인정보 보호 안내
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: BrandColors.c700,
                        borderRadius: BorderRadius.circular(8),
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
                  ComfirmButton(
                    text: '위치 정보 허용',
                    onPressed: () {
                      // 위치 정보 허용 로직
                      _handleLocationPermission(context, true);
                    },
                    width: MediaQuery.of(context).size.width - 32,
                    height: 52,
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

  Future<void> _handleLocationPermission(BuildContext context, bool isAllowed) async {
    if (isAllowed) {
      try {
        // 위치 서비스 활성화 여부 확인
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          _showLocationServiceDialog(context);
          return;
        }

        // 위치 권한 요청
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        if (permission == LocationPermission.denied) {
          _showPermissionDeniedSnackBar(context);
          return;
        }

        if (permission == LocationPermission.deniedForever) {
          _showPermissionDeniedForeverDialog(context);
          return;
        }

        // 권한 허용됨 - 위치 정보 테스트
        Position position = await Geolocator.getCurrentPosition();
        print('현재 위치: ${position.latitude}, ${position.longitude}');

        // 성공 메시지 표시
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('위치 정보가 허용되었습니다.'),
            backgroundColor: SecondaryColors.c500Default,
          ),
        );

        // 지도 페이지로 이동
        await Future.delayed(Duration(seconds: 1));
        if (context.mounted) {
          context.goNamed('map');
        }

      } catch (e) {
        print('위치 권한 요청 오류: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('위치 권한 요청 중 오류가 발생했습니다.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // 나중에 하기 처리
      print('위치 정보 나중에 하기');
      context.goNamed('map');
    }
  }

  void _showLocationServiceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: BrandColors.c800,
          title: Text(
            '위치 서비스 비활성화',
            style: TextStyle(color: BrandColors.txt30),
          ),
          content: Text(
            '위치 서비스가 비활성화되어 있습니다. 설정에서 위치 서비스를 활성화해주세요.',
            style: TextStyle(color: BrandColors.txt100),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                '확인',
                style: TextStyle(color: BrandColors.c500),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPermissionDeniedSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('위치 권한이 거부되었습니다.'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showPermissionDeniedForeverDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: BrandColors.c800,
          title: Text(
            '위치 권한 필요',
            style: TextStyle(color: BrandColors.txt30),
          ),
          content: Text(
            '위치 권한이 거부되어 있습니다. 설정에서 직접 권한을 허용해주세요.',
            style: TextStyle(color: BrandColors.txt100),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                '취소',
                style: TextStyle(color: BrandColors.txt300),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: Text(
                '설정으로 이동',
                style: TextStyle(color: BrandColors.c500),
              ),
            ),
          ],
        );
      },
    );
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
