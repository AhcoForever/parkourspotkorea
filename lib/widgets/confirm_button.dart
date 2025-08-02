import 'package:flutter/material.dart';

class ConfirmButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final Color color;

  const ConfirmButton({
    super.key,
    this.text = '확인',
    required this.onPressed,
    this.width = 320,
    this.height = 56,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(foregroundColor: color),
          onPressed: onPressed,
          child: Text(text),
        ),
      ),
    );
  }
}
