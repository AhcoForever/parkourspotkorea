import 'dart:ui';

class BrandColors {
  // 어두운 톤 (배경, 텍스트)
  static const Color c900 = Color(0xFF07071A); // 900-배경-더 어두운
  static const Color c800 = Color(0xFF0A1526); // 800-배경-어두운
  static const Color c700 = Color(0xFF142E59); // 700-배경

  // 메인 브랜드 색상
  static const Color c600Dark = Color(0xFF275CB2); // 600-버튼 호버(dark)
  static const Color c500 = Color(0xFF226DE5); // 500-버튼 (메인)

  // 밝은 톤
  static const Color c300 = Color(0xFF3381FF);
  static const Color c200 = Color(0xFF66A1FF);
  static const Color c100 = Color(0xFFCCE0FF);
  static const Color c50 = Color(0xFFEBF2FF);
  static const Color c20 = Color(0xFFF7FAFF);

  // 기본 텍스트
  static const Color normal = Color(0xFF455164);
}

class SecondaryColors {
  static const Color c900Inactive = Color(0xFF3D664C);
  static const Color c700 = Color(0xFF30A65B);
  static const Color c500Default = Color(0xFF3ED676); // 500-기본
  static const Color c300 = Color(0xFF46F286);
  static const Color c400Light = Color(0xFF639CF7); // 400-버튼 호버(light)
}

class StrokeColors {
  static const Color error = Color(0xFFC93E3E);
  static const Color success = Color(0xFF5AE54B);
  static const Color hover = BrandColors.c600Dark; // brand/600-버튼 호버(dark) 참조
  static const Color defaultStroke = Color(0xFF3D4D66);
}

class StatusColors {
  static const Color error = Color(0xFFFF4C4C);
  static const Color success = Color(0xFF5AE54B);
  static const Color successLight = Color(0xFF7AF26D);
  static const Color notification = Color(0xFFF8EE39);
}

