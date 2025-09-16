import 'package:flutter/material.dart';
import 'package:parkourspotkorea/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:parkourspotkorea/widgets/background_wrapper.dart';
import 'package:parkourspotkorea/widgets/comfirm_button.dart';
import 'dart:convert';

class NicknamePage extends StatefulWidget {
  @override
  _NicknamePageState createState() => _NicknamePageState();
}

class _NicknamePageState extends State<NicknamePage> {
  final TextEditingController _controller = TextEditingController();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_validate);
  }

  void _validate() {
    final text = _controller.text.trim();
    final byteLength = utf8.encode(text).length;
    setState(() {
      _isValid = text.isNotEmpty && byteLength <= 24; // 한글 8글자 (24바이트) 또는 영어 24글자
    });
  }

  void _onConfirm() {
    if (_isValid) {
      final nickname = _controller.text.trim();
      // TODO: 닉네임 저장 로직 구현
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('닉네임 "$nickname" 으로 설정되었습니다.')));

      // 닉네임 설정 완료 후 지도 페이지로 이동
      Future.delayed(Duration(seconds: 1), () {
        context.goNamed('map');
      });
    }
  }

  // 바이트 길이에 맞게 텍스트 자르기
  String _getValidText(String text, int maxBytes) {
    List<int> bytes = utf8.encode(text);
    if (bytes.length <= maxBytes) return text;

    // 바이트 길이를 초과하지 않는 최대 문자열 찾기
    String validText = '';
    for (int i = 0; i < text.length; i++) {
      String testText = text.substring(0, i + 1);
      if (utf8.encode(testText).length <= maxBytes) {
        validText = testText;
      } else {
        break;
      }
    }
    return validText;
  }

  // 바이트 카운터 텍스트 생성
  String _buildCounterText() {
    final currentBytes = utf8.encode(_controller.text).length;
    return '$currentBytes/24 bytes';
  }

  @override
  void dispose() {
    _controller.removeListener(_validate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.c900,
      appBar: AppBar(
        title: Text(
          '닉네임 설정',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        backgroundColor: BrandColors.c900,
      ),
      body: BackgroundWrapper(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // 로고 이미지
                Image.asset(
                  'assets/images/nickname-logo.png',
                  height: 100,
                ),
                Text(
                  '닉네임을 입력해주세요.',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: BrandColors.txt30,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '다른 사람에게 보여질 이름입니다. (추후 수정 가능)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: BrandColors.txt300,
                  ),
                ),
                const SizedBox(height: 36),
                TextField(
                  controller: _controller,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: BrandColors.txt30,
                  ),
                  onChanged: (text) {
                    // 바이트 길이 제한
                    if (utf8.encode(text).length > 24) {
                      final validText = _getValidText(text, 24);
                      _controller.value = TextEditingValue(
                        text: validText,
                        selection: TextSelection.collapsed(offset: validText.length),
                      );
                    }
                  },
                  decoration: InputDecoration(
                    hintText: '한글 8글자 또는 영어 24글자 이내',
                    hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                    counterText: _buildCounterText(),
                    filled: true,
                    fillColor: BrandColors.c800,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: StrokeColors.defaultStroke),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: StrokeColors.defaultStroke),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: BrandColors.c500, width: 2),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

         // Todo: 닉네임 설정 버튼 기능 구성하기
         ComfirmButton(onPressed: _onConfirm)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
