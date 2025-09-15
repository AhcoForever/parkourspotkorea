// widgets/background_wrapper.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parkourspotkorea/theme/app_colors.dart';

class BackgroundWrapper extends StatelessWidget {
  final Widget child;
  final bool showBackground;
  final double? svgWidth;
  final double? svgHeight;
  final String? customSvgPath;
  final AlignmentGeometry alignment;
  final Color? backgroundColor;

  const BackgroundWrapper({
    Key? key,
    required this.child,
    this.showBackground = true,
    this.svgWidth = 400,
    this.svgHeight = 400,
    this.customSvgPath,
    this.alignment = Alignment.center,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? BrandColors.c900,
      ),
      child: Stack(
        children: [
          // 배경 SVG
          if (showBackground)
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Align(
                alignment: alignment,
                child: SvgPicture.asset(
                  customSvgPath ?? 'assets/logo/background-logo.svg',
                  width: svgWidth,
                  height: svgHeight,
                ),
              ),
            ),

          // 콘텐츠
          child,
        ],
      ),
    );
  }
}