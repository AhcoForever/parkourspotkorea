import 'package:flutter/material.dart';

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
    setState(() {
      _isValid = text.isNotEmpty && text.characters.length <= 8;
    });
  }

  void _onConfirm() {
    if (_isValid) {
      final nickname = _controller.text.trim();
      // TODO: 닉네임 저장 로직 구현
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('닉네임 "$nickname" 으로 설정되었습니다.')));
    }
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('닉네임 설정'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Text(
              '닉네임을 입력해주세요.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '다른 사람에게 보여질 이름입니다.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 24),
            TextField(
              controller: _controller,
              maxLength: 8,
              decoration: InputDecoration(
                hintText: '최대 8글자',
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.orange),
                ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isValid ? _onConfirm : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  disabledForegroundColor: Colors.orange.shade200.withOpacity(
                    0.38,
                  ),
                  disabledBackgroundColor: Colors.orange.shade200.withOpacity(
                    0.12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  '확인',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
