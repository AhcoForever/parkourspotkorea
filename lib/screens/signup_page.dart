import 'package:flutter/material.dart';

class SignupCompleteDialog extends StatelessWidget {
  final VoidCallback? onConfirm;

  const SignupCompleteDialog({
    Key? key,
    this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),

            // 제목
            Text(
              '회원가입 완료',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 16),

            // 부제목
            Text(
              '이제 로그인이 가능합니다',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 32),

            // 확인 버튼
            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onConfirm != null) {
                    onConfirm!();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF8A3D),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  '확인',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // 다이얼로그 표시 헬퍼 메서드
  static void show(
      BuildContext context, {
        VoidCallback? onConfirm,
      }) {
    showDialog(
      context: context,
      barrierDismissible: false, // 배경 터치로 닫기 불가
      builder: (BuildContext context) {
        return SignupCompleteDialog(onConfirm: onConfirm);
      },
    );
  }
}

// 사용 예시
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _agreeToTerms = false;
  bool _isAdult = false;
  bool _agreeToService = false;
  bool _agreeToPrivacy = false;
  bool _agreeToLocation = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '회원가입',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 이메일 입력
                _buildLabel('이메일 아이디', true),
                SizedBox(height: 8),
                _buildTextField(
                  controller: _emailController,
                  hintText: '이메일',
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),

                // 비밀번호 입력
                _buildLabel('비밀번호', true),
                SizedBox(height: 8),
                _buildTextField(
                  controller: _passwordController,
                  hintText: '영문+숫자+특수문자 조합 8~16자리',
                  obscureText: true,
                ),
                SizedBox(height: 20),

                // 비밀번호 확인
                _buildLabel('비밀번호 확인', true),
                SizedBox(height: 8),
                _buildTextField(
                  controller: _confirmPasswordController,
                  hintText: '',
                  obscureText: true,
                ),
                SizedBox(height: 20),

                // 휴대폰 번호
                _buildLabel('휴대폰 번호', true),
                SizedBox(height: 8),
                _buildTextField(
                  controller: _phoneController,
                  hintText: '',
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 30),

                // 약관 동의 안내
                Text(
                  '사이트 이용을 위한 약관에 동의해 주세요.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 20),

                // 전체 동의
                _buildCheckboxRow(
                  '네, 모두 동의합니다.',
                  _agreeToTerms,
                      (value) {
                    setState(() {
                      _agreeToTerms = value ?? false;
                      if (_agreeToTerms) {
                        _isAdult = true;
                        _agreeToService = true;
                        _agreeToPrivacy = true;
                        _agreeToLocation = true;
                      } else {
                        _isAdult = false;
                        _agreeToService = false;
                        _agreeToPrivacy = false;
                        _agreeToLocation = false;
                      }
                    });
                  },
                  isBold: true,
                ),
                SizedBox(height: 15),

                // 개별 약관들
                _buildCheckboxRowWithButton(
                  '[필수] 만 14세 이상입니다.',
                  _isAdult,
                      (value) {
                    setState(() {
                      _isAdult = value ?? false;
                      _updateMainCheckbox();
                    });
                  },
                ),
                SizedBox(height: 10),

                _buildCheckboxRowWithButton(
                  '[필수] 서비스 이용약관',
                  _agreeToService,
                      (value) {
                    setState(() {
                      _agreeToService = value ?? false;
                      _updateMainCheckbox();
                    });
                  },
                ),
                SizedBox(height: 10),

                _buildCheckboxRowWithButton(
                  '[필수] 개인정보 수집/이용동의',
                  _agreeToPrivacy,
                      (value) {
                    setState(() {
                      _agreeToPrivacy = value ?? false;
                      _updateMainCheckbox();
                    });
                  },
                ),
                SizedBox(height: 10),

                _buildCheckboxRowWithButton(
                  '[필수]위치기반 서비스 이용약관',
                  _agreeToLocation,
                      (value) {
                    setState(() {
                      _agreeToLocation = value ?? false;
                      _updateMainCheckbox();
                    });
                  },
                ),
                SizedBox(height: 40),

                // 회원가입 버튼
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _canSignUp() ? _handleSignUp : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _canSignUp() ? Color(0xFFFF8A3D) : Colors.grey[300],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      '회원가입',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, bool isRequired) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        if (isRequired)
          Text(
            ' *',
            style: TextStyle(
              fontSize: 14,
              color: Colors.red,
            ),
          ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildCheckboxRow(String text, bool value, Function(bool?) onChanged, {bool isBold = false}) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: Color(0xFFFF8A3D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxRowWithButton(String text, bool value, Function(bool?) onChanged) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: Color(0xFFFF8A3D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            // 약관 보기 기능
            print('$text 보기');
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size(40, 30),
          ),
          child: Text(
            '보기',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  void _updateMainCheckbox() {
    setState(() {
      _agreeToTerms = _isAdult && _agreeToService && _agreeToPrivacy && _agreeToLocation;
    });
  }

  bool _canSignUp() {
    return _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _isAdult &&
        _agreeToService &&
        _agreeToPrivacy &&
        _agreeToLocation;
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      // 회원가입 처리 로직
      print('회원가입 처리 시작...');

      // 여기서 실제 회원가입 API 호출
      // 성공하면 다이얼로그 표시
      _showSignupCompleteDialog();
    }
  }

  void _showSignupCompleteDialog() {
    SignupCompleteDialog.show(
      context,
      onConfirm: () {
        // 확인 버튼 클릭 시 로그인 화면으로 이동
        Navigator.of(context).popUntil((route) => route.isFirst);
        // 또는 로그인 화면으로 이동
        // Navigator.pushReplacementNamed(context, '/login');
      },
    );
  }
}
