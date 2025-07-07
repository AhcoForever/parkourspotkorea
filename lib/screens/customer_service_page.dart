import 'package:flutter/material.dart';

class CustomerServicePage extends StatelessWidget {
  const CustomerServicePage({Key? key}) : super(key: key);

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

            // QR 코드 플레이스홀더
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: const Center(
                child: Text(
                  'QR 코드\n영역',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            const Spacer(),

            // 하단 인디케이터
            Container(
              width: 134,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

// 사용 예시:
// Navigator.push(
//   context,
//   MaterialPageRoute(builder: (context) => const CustomerServicePage()),
// );