import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: BrandColors.c500,
        tertiary: BrandColors.c700,
      ).copyWith(secondary: BrandColors.c300, error: StatusColors.error),

      // 폰트
      fontFamily: 'Pretendard',

      // 배경색 - 가장 어두운 톤 사용
      scaffoldBackgroundColor: BrandColors.c900,

      // App bar 테마
      appBarTheme: AppBarTheme(
        backgroundColor: BrandColors.c800,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: BrandColors.txtWhite,
        ),
      ),

      // ElevatedButton 테마
      elevatedButtonTheme: ElevatedButtonThemeData(
        style:
            ElevatedButton.styleFrom(
              backgroundColor: SecondaryColors.c500Default,
              // 메인 브랜드 색상
              foregroundColor: Color(0xFFFCFCFC),
              disabledBackgroundColor: SecondaryColors.c700,
              disabledForegroundColor: BrandColors.c900,
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 17, vertical: 12),
            ).copyWith(
              // 호버 상태
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.hovered)) {
                  return Color(0xFF32AD5F);
                }
                return BrandColors.c500;
              }),
            ),
      ),

      // Text 테마 - 밝은 색상 사용
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: BrandColors.c50, // 가장 밝은 색상
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: BrandColors.c50,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: BrandColors.c100,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: BrandColors.c100, // 본문 텍스트
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: BrandColors.c100,
        ),
        bodySmall: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.normal,
          color: BrandColors.c200, // 약간 흐린 텍스트
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: BrandColors.c100,
        ),
        titleLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: BrandColors.c300, // 브랜드 색상의 밝은 버전
        ),
      ),

      // 텍스트 버튼 테마
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: BrandColors.c200,
          // 밝은 회색
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),

      // 다이얼로그 테마
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: BrandColors.c800,
        // 어두운 배경
        elevation: 4,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: BrandColors.c50, // 밝은 제목
        ),
        contentTextStyle: TextStyle(
          fontSize: 14,
          color: BrandColors.c100, // 밝은 내용 텍스트
        ),
        alignment: Alignment.center,
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
      ),

      // 텍스트 필드 테마
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: BrandColors.c800,
        // 어두운 입력 필드 배경
        labelStyle: TextStyle(color: BrandColors.txt500),
        // 밝은 라벨
        hintStyle: TextStyle(color: BrandColors.txt30),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 17,
        ),

        // 기본 테두리 - Stroke 색상 활용
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: StrokeColors.defaultStroke, width: 1),
        ),

        // 포커스 테두리 - 브랜드 색상
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: SecondaryColors.c500Default, width: 2),
        ),

        // 오류 테두리 - Stroke 오류 색상
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: StrokeColors.error, width: 1),
        ),

        // 포커스된 오류 테두리
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: StrokeColors.error, width: 2),
        ),
      ),

      // 텍스트 필드 입력 텍스트 색상
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: BrandColors.c500,
        selectionColor: BrandColors.c500.withOpacity(0.3),
        selectionHandleColor: BrandColors.c500,
      ),

      // FloatingActionButton 테마
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: BrandColors.c700.withValues(alpha: 0.8), // 반투명 어두운 배경
        elevation: 5,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: BrandColors.c600Dark), // 브랜드 테두리
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }

  static ThemeData get light => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      //primary 색상군
      seedColor: Color(0xFF3A59D1),
      tertiary: Color(0xFFCAD2F3),
    ).copyWith(secondary: Color(0xFF202632)),

    //폰트
    fontFamily: 'Pretendard',

    scaffoldBackgroundColor: const Color(0xFFF4F7FE),
    //App bar 테마
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF4F7FE),
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.normal,
        color: Color(0xFF121212),
      ),
    ),

    ///ElevatedButton 테마
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF226DE5),
        foregroundColor: Colors.white,

        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(horizontal: 17, vertical: 12),
      ),
    ),

    //Text 테마
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Color(0xFF202632),
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Color(0xFF202632),
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF202632),
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0xFF202632),
      ),

      /// 14, w400, 검정
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF202632),
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Color(0xFF9E9E9E),
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF202632),
      ),
      titleLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Color(0xFF3A59D1),
      ),
    ),

    //텍스트 버튼 테마
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Color(0xFF6A707C),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ),

    //다이얼로그 테마
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Color(0xFFF4F7FE),
      elevation: 4,

      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),

      contentTextStyle: TextStyle(fontSize: 14, color: Color(0xFF4D4D4D)),
      alignment: Alignment.center,
      actionsPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    ),

    //텍스트 필드 테마
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFFF9F9F9),
      labelStyle: TextStyle(color: Color(0xFF6A707C)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      //비포커스 상태의 테두리
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: Color(0xFFCAD2F3), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: Color(0xFF0064FF), width: 2),
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0x99F4F7FE),

      elevation: 5,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color(0xFFCAD2F3)),
        borderRadius: BorderRadius.circular(50),
      ),
    ),
  );
}
