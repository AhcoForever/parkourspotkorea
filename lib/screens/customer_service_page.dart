import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerServicePage extends StatelessWidget {
  const CustomerServicePage({Key? key}) : super(key: key);

  //QR코드 URL
  final String _qrcodeUrl = 'https://open.kakao.com/me/parkourspotcustomer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
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
            // 이메일 주소
            const Text(
              'ahco8766@gmail.com',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),

            // "or" 텍스트
            Text(
              'or',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 20),

            // 카카오톡 문의 텍스트
            const Text(
              '카카오톡 문의',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),

            const Text(
              'https://open.kakao.com/me/parkourspotcustomer',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            // QR 코드 이미지
             Image.asset('assets/QRcode/CustomerService_QRcode.jpeg'),
            const SizedBox(height: 30),



          ],

        ),
      ),
    );
  }
}
