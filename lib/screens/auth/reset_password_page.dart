import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parkourspotkorea/theme/app_colors.dart';
import 'package:parkourspotkorea/widgets/comfirm_button.dart';
import 'package:parkourspotkorea/widgets/background_wrapper.dart'; // BackgroundWrapper import 추가
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

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
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
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
                  style: TextStyle(color: BrandColors.txt30),
                  decoration: InputDecoration(
                    hintText: '@ 까지 정확하게 입력해 주세요.',
                    hintStyle: TextStyle(
                      color: BrandColors.txt500,
                      fontSize: 13,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 17,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),

              SizedBox(height: 20),
              Text(
                '* 비밀번호 재설정 이메일이 스팸함으로 분류될 수 있습니다. \n   메일함을 확인해 주세요.',
                style: TextStyle(color: BrandColors.txt500, fontSize: 12),
              ),
              SizedBox(height: 20,),
              // Confirm button
              ComfirmButton(
                text: _isLoading ? '전송 중...' : '비밀번호 재설정',
                onPressed: _isLoading
                    ? null
                    : () {
                        // 이메일 입력 검증 추가
                        if (_emailController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('이메일 주소를 입력해 주세요.'),
                              backgroundColor: StrokeColors.error,
                            ),
                          );
                          return;
                        }

                        if (!_isValidEmail(_emailController.text.trim())) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('올바른 이메일 형식을 입력해 주세요.'),
                              backgroundColor: StrokeColors.error,
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
  Future<void> _sendPasswordResetEmail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Firebase Auth를 통한 비밀번호 재설정 이메일 전송
      print('비밀번호 재설정 이메일 전송 시도: ${_emailController.text.trim()}'); // 디버그 로그 추가
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      print('비밀번호 재설정 이메일 전송 성공'); // 디버그 로그 추가

      // 성공 메시지 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '비밀번호 재설정 이메일을 보내드렸습니다.\n이메일을 확인해 주세요.',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            backgroundColor: SecondaryColors.c500Default,
            duration: Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );

        // 이메일 입력 필드 초기화
        _emailController.clear();

        // 3초 후 로그인 페이지로 이동
        Future.delayed(Duration(seconds: 3), () {
          if (mounted) {
            context.goNamed('login');
          }
        });
      }
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth 에러: ${e.code} - ${e.message}'); // 디버그 로그 추가
      String errorMessage = '';

      switch (e.code) {
        case 'user-not-found':
          errorMessage = '해당 이메일로 가입된 계정이 없습니다.';
          break;
        case 'invalid-email':
          errorMessage = '올바른 이메일 형식을 입력해 주세요.';
          break;
        case 'too-many-requests':
          errorMessage = '요청이 너무 많습니다. 잠시 후 다시 시도해 주세요.';
          break;
        default:
          errorMessage = '이메일 전송에 실패했습니다. 다시 시도해 주세요.';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            backgroundColor: StrokeColors.error,
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      print('일반 에러: $e'); // 디버그 로그 추가
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '알 수 없는 오류가 발생했습니다. 다시 시도해 주세요.',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            backgroundColor: StrokeColors.error,
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
