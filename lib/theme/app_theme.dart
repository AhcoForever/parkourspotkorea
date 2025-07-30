import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      //primary 색상군
      seedColor: Color(0xFF0064FF),
    ).copyWith(secondary: Color(0xFF202632)),

    //폰트
    fontFamily: 'Pretendard',

    ///ElevatedButton 테마
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(

        backgroundColor: const Color(0xFF0064FF),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(horizontal: 17, vertical: 12),
      ),
    ),

    //Text 테마
    textTheme: TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),

    //텍스트 버튼 테마
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Color(0xFF6A707C),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ),

    //다이얼로그 테마
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      elevation: 4,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      contentTextStyle: TextStyle(fontSize: 14, color: Colors.grey[600]),
      alignment: Alignment.center,
      actionsPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    ),

    //텍스트 필드 테마
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: Color(0xFF6A707C)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      //비포커스 상태의 테두리
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xFFD0D0D0), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xFF0064FF), width: 2),
      ),
    ),

  );
}
