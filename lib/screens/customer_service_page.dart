import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/back_button.dart';

class CustomerServicePage extends StatelessWidget {
  const CustomerServicePage({Key? key}) : super(key: key);

  // QR코드 URL
  final String _qrcodeUrl = 'https://open.kakao.com/me/parkourspotcustomer';

  Future<void> _launchKakao(BuildContext context) async {
    final uri = Uri.parse(_qrcodeUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('링크를 열 수 없습니다.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => smartBack(context),
        ),
        title: const Text(
          '고객 지원',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'ahco8766@gmail.com',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'or',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '카카오톡 문의',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),

            // 클릭 가능한 링크로 대체
            GestureDetector(
              onTap: () => _launchKakao(context),
              child: const Text(
                'https://open.kakao.com/me/parkourspotcustomer',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,

                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // QR 코드 이미지
            GestureDetector(
              onTap: () => _launchKakao(context),
              child: Image.asset(
                'assets/QRcode/CustomerService_QRcode.jpeg',
                width: 200,
                height: 200,
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
