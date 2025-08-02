import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parkourspotkorea/services/auth_service.dart';
import 'package:parkourspotkorea/widgets/confirm_button.dart';
import '../widgets/back_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _displaynmController = TextEditingController();
  final _parkourProficiencyController = TextEditingController();

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
    _displaynmController.dispose();
    _parkourProficiencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Color(0xFF202632)),
          onPressed: () => smartBack(context),
        ),
        title: Text('회원가입', style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                SizedBox(height: 20),

                // 전체 동의
                _buildCheckboxRow('네, 모두 동의합니다.', _agreeToTerms, (value) {
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
                }, isBold: true),
                SizedBox(height: 15),

                // 개별 약관들
                _buildCheckboxRowWithButton('[필수] 만 14세 이상입니다.', _isAdult, (
                  value,
                ) {
                  setState(() {
                    _isAdult = value ?? false;
                    _updateMainCheckbox();
                  });
                }),
                SizedBox(height: 10),

                _buildCheckboxRowWithButton('[필수] 서비스 이용약관', _agreeToService, (
                  value,
                ) {
                  setState(() {
                    _agreeToService = value ?? false;
                    _updateMainCheckbox();
                  });
                }),
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
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _canSignUp() ? _handleSignUp : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _canSignUp()
                          ? Color(0xFFFF8A3D)
                          : Colors.grey[300],
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
          Text(' *', style: TextStyle(fontSize: 14, color: Colors.red)),
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
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildCheckboxRow(
    String text,
    bool value,
    Function(bool?) onChanged, {
    bool isBold = false,
  }) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: Color(0xFFFF8A3D),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
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

  Widget _buildCheckboxRowWithButton(
    String text,
    bool value,
    Function(bool?) onChanged,
  ) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: Color(0xFFFF8A3D),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
        ),
        TextButton(
          onPressed: () {
            // 약관 보기 기능
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
//
  Future<void> _showSignupCompleteDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,

      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '회원가입 완료',
                style: Theme.of(context).dialogTheme.titleTextStyle,
              ),
              const SizedBox(height: 16),
              Text(
                '이제 로그인이 가능합니다!',
                style: Theme.of(context).dialogTheme.contentTextStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ConfirmButton(
                onPressed: () {
                  context.goNamed('/login');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateMainCheckbox() {
    setState(() {
      _agreeToTerms =
          _isAdult && _agreeToService && _agreeToPrivacy && _agreeToLocation;
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

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      // 회원가입 처리 로직
      await AuthService().signup(
        email: _emailController.text,
        password: _passwordController.text,
        displayName: _displaynmController.text,
        parkourProficiency: _parkourProficiencyController.text,
        phoneNum: int.parse(_phoneController.text.trim()),
      );

      // 여기서 실제 회원가입 API 호출
      // 성공하면 다이얼로그 표시
      await _showSignupCompleteDialog(context);
    }
  }
}
