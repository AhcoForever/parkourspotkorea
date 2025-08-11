import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      //primary 색상군
      seedColor: Color(0xFF3A59D1),
      tertiary: Color(0xFFCAD2F3),
    ).copyWith(secondary: Color(0xFF202632)),

    //폰트
    fontFamily: 'Pretendard',
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
        backgroundColor: const Color(0xFF3A59D1),
        foregroundColor: Colors.white,

        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xFFCAD2F3), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
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
