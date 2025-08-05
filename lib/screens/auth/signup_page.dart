import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parkourspotkorea/services/auth_service.dart';
import '../../widgets/back_button.dart';
import '../../widgets/dialogs/signup_complete_dialog.dart';

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
      backgroundColor: Color(0xFFF4F7FE),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
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
                  hintText: 'parkourspot@gmail.com',
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
                  hintText: '비밀번호 재입력',
                  obscureText: true,
                ),
                SizedBox(height: 20),

                // 휴대폰 번호
                _buildLabel('휴대폰 번호', true),
                SizedBox(height: 8),
                _buildTextField(
                  controller: _phoneController,
                  hintText: '010-0000-0000',
                  keyboardType: TextInputType.phone,
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
                SizedBox(height: 30),

                // 회원가입 버튼
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _canSignUp() ? _handleSignUp : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _canSignUp()
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[300],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
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
        Text(text, style: Theme.of(context).textTheme.bodySmall),
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
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.bodySmall,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          activeColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Color(0xFF4D4D4D),
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
          activeColor: Theme.of(context).colorScheme.primary,
          checkColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          side: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.4)),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: Color(0xFF4D4D4D),
            ),
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
  Future<void> _showSignupCompleteDialog(BuildContext context) async {
    await SignupCompleteDialog.show(context, () {
      context.goNamed('/login');
    });
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
    }
    await SignupCompleteDialog.show(context, () {
      // 다이얼로그 확인 버튼 누르면 로그인 페이지로 이동
      context.go('/login');
    });
  }
}
