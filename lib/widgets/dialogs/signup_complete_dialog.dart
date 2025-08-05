import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parkourspotkorea/widgets/confirm_button.dart';

///회원가입 완료 다이얼로그
///사용자에게 회원가입 완료를 알리고 로그인 페이지로 이동
class SignupCompleteDialog extends StatelessWidget {
  final VoidCallback? onConfirm;

  const SignupCompleteDialog({super.key, this.onConfirm});

  static Future<void> show(BuildContext context, VoidCallback? onConfirm) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          SignupCompleteDialog(onConfirm: onConfirm),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '회원가입 완료',
              style: Theme.of(context).textTheme.titleLarge,

            ),
            const SizedBox(height: 8),

            Text(
              '파쿠르 스팟에 오신 것을 환영합니다!',
              textAlign: TextAlign.center,
              style: Theme.of(context).dialogTheme.contentTextStyle?.copyWith(
                height: 1.5, // 줄간격 조정
              ),
            ),
            const SizedBox(height: 18),
            ConfirmButton(onPressed:()=> context.go('/login'),),
          ],
        ),
      ),
    );

  }
}
