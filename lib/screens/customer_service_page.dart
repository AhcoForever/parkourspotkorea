import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:parkourspotkorea/theme/app_colors.dart';

class CustomerServicePage extends StatelessWidget {
  const CustomerServicePage({Key? key}) : super(key: key);

  // 이메일 보내기 함수
  Future<void> _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'ahco8766@gmail.com',
      queryParameters: {'subject': '문의사항', 'body': '안녕하세요.\n\n문의내용을 작성해주세요.'},
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        throw '메일 앱을 열 수 없습니다.';
      }
    } catch (e) {
      print('이메일 오류: $e');
    }
  }

  // 카카오톡 채널 이동 함수
  Future<void> _openKakaoChannel() async {
    const String kakaoChannelUrl =
        'https://open.kakao.com/me/parkourspotcustomer';

    final Uri uri = Uri.parse(kakaoChannelUrl);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw '카카오톡 채널을 열 수 없습니다.';
      }
    } catch (e) {
      print('카카오톡 채널 오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '고객센터',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: BrandColors.txtWhite,
          ),
        ),
        leading: IconButton(
          padding: const EdgeInsets.only(left: 20),
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.goNamed('login');
          },
        ),
        backgroundColor: BrandColors.c900,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            SizedBox(height: 77),

            // 이메일 문의 섹션
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: BrandColors.c800,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: [
                  // 헤더
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: SecondaryColors.c500Default,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                    ),
                    child: Text(
                      '이메일 문의',
                      style: TextStyle(
                        color: BrandColors.c900,
                        fontWeight: FontWeight.w600,
                      )?.copyWith(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // 내용
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: GestureDetector(
                      onTap: _sendEmail,
                      child: Text(
                        'ahco8766@gmail.com',
                        style: textTheme.bodyLarge?.copyWith(
                          color: BrandColors.txtWhite,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 카카오톡 문의 섹션
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: BrandColors.c800,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: [
                  // 헤더
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(4),
                        topLeft: Radius.circular(4),
                      ),
                      color: SecondaryColors.c500Default,
                    ),
                    child: Text(
                      '카카오톡 문의',
                      style: TextStyle(
                        color: BrandColors.c900,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // 내용
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text(
                          'QR 코드를 탭하거나 스캔하면 \n카카오 문의 채널로 이동합니다.',
                          style: TextStyle(
                            color: BrandColors.txt30,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        // QR 코드 이미지
                        GestureDetector(
                          onTap: _openKakaoChannel,
                          child: Container(
                            width: 150,
                            height: 150,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/QRcode/CustomerService_QRcode.jpeg',
                                // QR 코드 이미지 경로
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    child: Icon(Icons.qr_code, size: 60),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
