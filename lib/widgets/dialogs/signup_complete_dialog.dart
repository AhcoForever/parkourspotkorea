import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parkourspotkorea/screens/signup_page.dart';
import 'package:parkourspotkorea/widgets/confirm_button.dart';

class SignupCompleteDialog extends StatelessWidget {
  const SignupCompleteDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SignUpPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('회원가입 완료')),
      content: Text('이제 로그인이 가능합니다!', textAlign: TextAlign.center),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        SizedBox(
          width: 20,
          child: ConfirmButton(onPressed: () => context.goNamed('/login')),
        ),
      ],
    );
  }
}
