import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ComfirmButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final Color color;
  final Color textColor;

  const ComfirmButton({
    super.key,
    this.text = '확인',
    required this.onPressed,
    this.width = 360,
    this.height = 55,
    this.color = BrandColors.c900,
    this.textColor = BrandColors.c900,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        height: height,

        child: ElevatedButton(

          style: ElevatedButton.styleFrom(
            foregroundColor: color,
            backgroundColor: SecondaryColors.c500Default,
            disabledBackgroundColor: BrandColors.normal,
            disabledForegroundColor: BrandColors.txt500,
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 18,
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
