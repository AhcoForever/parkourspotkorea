import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parkourspotkorea/theme/app_colors.dart';
import 'package:parkourspotkorea/widgets/comfirm_button.dart';
import 'package:parkourspotkorea/widgets/background_wrapper.dart'; // BackgroundWrapper import 추가
import 'package:firebase_auth/firebase_auth.dart';

class FindIDPW extends StatefulWidget {
  @override
  _FindIDPWState createState() => _FindIDPWState();
}

class _FindIDPWState extends State<FindIDPW> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.goNamed('login');
          },
        ),
        title: Text('비밀번호 재설정'),
        backgroundColor: BrandColors.c900,
        centerTitle: true,
      ),
      body: BackgroundWrapper(
        // 배경 설정 옵션들
        showBackground: true,
        svgWidth: 200,
        svgHeight: 200,
        alignment: Alignment.center,
        backgroundColor: BrandColors.c900,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Email input section
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '이메일 아이디',
                      style: textTheme.bodySmall?.copyWith(
                        color: BrandColors.txt30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: ' *',
                      style: textTheme.bodySmall?.copyWith(
                        color: StrokeColors.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 8),

              Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: '@ 까지 정확하게 입력해 주세요.',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),

              SizedBox(height: 30),

              // Confirm button
              ComfirmButton(
                text: '비밀번호 재설정',
                onPressed: () {
                  // 이메일 입력 검증 추가
                  if (_emailController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('이메일 주소를 입력해 주세요.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  if (!_isValidEmail(_emailController.text.trim())) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('올바른 이메일 형식을 입력해 주세요.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  // 비밀번호 재설정 이메일 전송 로직 구현
                  _sendPasswordResetEmail();
                },
              ),

              SizedBox(height: 20),

              // Information text
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 4,
                    height: 4,
                    margin: EdgeInsets.only(top: 8, right: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          height: 1.4,
                        ),
                        children: [
                          TextSpan(text: '비밀번호 재설정에 어려움이 있으시다면 '),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () {
                                // 고객센터 페이지로 이동
                                context.goNamed('customerService');
                              },
                              child: Text(
                                '고객센터 ',
                                style: TextStyle(
                                  color: BrandColors.txt300,
                                  fontSize: 13,
                                  decoration: TextDecoration.underline,
                                  decorationColor: BrandColors.txt300,
                                ),
                              ),
                            ),
                          ),
                          TextSpan(text: '로 문의 바랍니다.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // 추가 여백으로 스크롤 공간 확보
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  // 이메일 형식 검증 함수
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // 비밀번호 재설정 이메일 전송 함수
  void _sendPasswordResetEmail() {
    // TODO: 실제 이메일 전송 API 호출 구현
    print('비밀번호 재설정 이메일 전송: ${_emailController.text}');

    // 성공 메시지 표시
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('비밀번호 재설정 이메일을 보내드렸습니다.\n이메일을 확인해 주세요.'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );

    // 이메일 입력 필드 초기화 (선택사항)
    _emailController.clear();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}