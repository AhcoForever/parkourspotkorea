import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parkourspotkorea/theme/app_colors.dart';
import 'package:parkourspotkorea/widgets/comfirm_button.dart';

/// 회원가입 완료 다이얼로그
/// 사용자에게 회원가입 완료를 알리고 로그인 페이지로 이동
class SignupCompleteDialog extends StatelessWidget {
  final VoidCallback? onConfirm;
  final String? title;
  final String? message;

  const SignupCompleteDialog({
    super.key,
    this.onConfirm,
    this.title,
    this.message,
  });

  static Future<void> show(
    BuildContext context,
    VoidCallback? onConfirm, {
    String? title,
    String? message,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => SignupCompleteDialog(
        onConfirm: onConfirm,
        title: title,
        message: message,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: BrandColors.c800,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Text(
              title ?? '회원가입 완료',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                height: 1.33,
                color: BrandColors.c500,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message ?? '파쿠르 스팟에 오신 것을 환영합니다!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: BrandColors.txtWhite,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ComfirmButton(onPressed: onConfirm),
          ],
        ),
      ),
    );
  }
}
