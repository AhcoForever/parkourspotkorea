import 'package:flutter/material.dart';

class LocationPermissionPage extends StatelessWidget {
  const LocationPermissionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 위치 아이콘
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.location_on,
                        size: 60,
                        color: Colors.orange,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // 메인 제목
                    const Text(
                      '위치 정보 사용 허용',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 24),

                    // 설명 텍스트
                    const Text(
                      '회원님 주변의 파쿠르 장소를 찾아드리기 위해\n위치 정보 사용 권한이 필요해요.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 32),

                    // 기능 목록
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          _buildFeatureItem(
                            icon: Icons.explore,
                            text: '내 주변 파쿠르 스팟 추천',
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 16),
                          _buildFeatureItem(
                            icon: Icons.map,
                            text: '거리 기반 장소 정보 제공',
                            color: Colors.green,
                          ),
                          const SizedBox(height: 16),
                          _buildFeatureItem(
                            icon: Icons.favorite,
                            text: '나만의 파쿠르 맵 생성',
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 개인정보 보호 안내
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.security,
                            color: Colors.blue,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '위치 정보는 안전하게 보호되며,\n언제든지 설정에서 변경할 수 있어요.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue.shade700,
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
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        '위치 정보 허용',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Text(
                        '나중에 하기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
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
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 18,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
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
        const SnackBar(
          content: Text('위치 정보가 허용되었습니다.'),
          backgroundColor: Colors.green,
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
  runApp(MaterialApp(
    home: const LocationPermissionPage(),
    theme: ThemeData(
      fontFamily: 'NotoSans',
    ),
  ));
}