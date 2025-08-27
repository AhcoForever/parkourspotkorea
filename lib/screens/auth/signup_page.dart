import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../model/signup.dart';
import '../../viewmodel/signup_viewmodel.dart';
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
  final _parkourProficiencyController = TextEditingController();

  late SignupViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<SignupViewModel>();
    _setupControllerListeners();
    _setupViewModelListeners();
  }

  void _setupControllerListeners() {
    _emailController.addListener(
      () => _viewModel.updateEmail(_emailController.text),
    );
    _passwordController.addListener(
      () => _viewModel.updatePassword(_passwordController.text),
    );
    _confirmPasswordController.addListener(
      () => _viewModel.updateConfirmPassword(_confirmPasswordController.text),
    );
    _phoneController.addListener(
      () => _viewModel.updatePhoneNumber(_phoneController.text),
    );

    _parkourProficiencyController.addListener(
      () => _viewModel.updateParkourProficiency(
        _parkourProficiencyController.text,
      ),
    );
  }

  void _setupViewModelListeners() {
    _viewModel.addListener(() {
      final state = _viewModel.state;

      // 회원가입 성공 시 다이얼로그 표시
      if (state.status == SignupStatus.success) {
        _showSignupCompleteDialog();
      }

      // 에러 발생 시 스낵바 표시
      if (state.status == SignupStatus.error && state.errorMessage != null) {
        _showErrorSnackbar(state.errorMessage!);
        _viewModel.clearError();
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _parkourProficiencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF4F7FE),
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_sharp,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () => smartBack(context),
            ),
            title: Text(
              '회원가입',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildEmailField(viewModel),
                        const SizedBox(height: 20),

                        _buildPasswordField(viewModel),
                        const SizedBox(height: 20),

                        _buildConfirmPasswordField(viewModel),
                        const SizedBox(height: 20),

                        _buildPhoneField(viewModel),
                        const SizedBox(height: 20),

                        _buildTermsSection(viewModel),
                        const SizedBox(height: 30),

                        _buildSignupButton(viewModel),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),

              // 로딩 오버레이
              if (viewModel.isLoading)
                Container(
                  color: Colors.black.withAlpha(77),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmailField(SignupViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('이메일 아이디', true),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _emailController,
          hintText: 'parkourspot@gmail.com',
          keyboardType: TextInputType.emailAddress,
          errorText: viewModel.validationErrors['email'],
        ),
      ],
    );
  }

  Widget _buildPasswordField(SignupViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('비밀번호', true),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _passwordController,
          hintText: '영문+숫자+특수문자 조합 8~16자리',
          obscureText: true,
          errorText: viewModel.validationErrors['password'],
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField(SignupViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('비밀번호 확인', true),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _confirmPasswordController,
          hintText: '비밀번호 재입력',
          obscureText: true,
          errorText: viewModel.validationErrors['confirmPassword'],
        ),
      ],
    );
  }

  Widget _buildPhoneField(SignupViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('휴대폰 번호', true),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _phoneController,
          hintText: '01012345678',
          keyboardType: TextInputType.phone,
          errorText: viewModel.validationErrors['phoneNumber'],
        ),
      ],
    );
  }

  Widget _buildTermsSection(SignupViewModel viewModel) {
    final terms = viewModel.termsAgreement;

    return Column(
      children: [
        _buildCheckboxRow(
          '네, 모두 동의합니다.',
          terms.agreeToAll,
          (value) => viewModel.updateTermsAgreement(agreeToAll: value),
          isBold: true,
        ),
        const SizedBox(height: 15),

        _buildCheckboxRowWithButton(
          '[필수] 만 14세 이상입니다.',
          terms.isAdult,
          (value) => viewModel.updateTermsAgreement(isAdult: value),
        ),
        const SizedBox(height: 10),

        _buildCheckboxRowWithButton(
          '[필수] 서비스 이용약관',
          terms.agreeToService,
          (value) => viewModel.updateTermsAgreement(agreeToService: value),
        ),
        const SizedBox(height: 10),

        _buildCheckboxRowWithButton(
          '[필수] 개인정보 수집/이용동의',
          terms.agreeToPrivacy,
          (value) => viewModel.updateTermsAgreement(agreeToPrivacy: value),
        ),
        const SizedBox(height: 10),

        _buildCheckboxRowWithButton(
          '[필수] 위치기반 서비스 이용약관',
          terms.agreeToLocation,
          (value) => viewModel.updateTermsAgreement(agreeToLocation: value),
        ),
      ],
    );
  }

  Widget _buildSignupButton(SignupViewModel viewModel) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: viewModel.canSignUp && !viewModel.isLoading
            ? () => viewModel.signUp()
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: viewModel.canSignUp
              ? Theme.of(context).colorScheme.primary
              : Colors.grey[300],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: viewModel.isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                '회원가입',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  Widget _buildLabel(String text, bool isRequired) {
    return Row(
      children: [
        Text(text, style: Theme.of(context).textTheme.bodySmall),
        if (isRequired)
          const Text(' *', style: TextStyle(fontSize: 14, color: Colors.red)),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.bodySmall,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        errorText: errorText,
        errorStyle: const TextStyle(fontSize: 12),
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
              color: const Color(0xFF4D4D4D),
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
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary.withAlpha(102),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: Color(0xFF4D4D4D),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            // 약관 보기 기능 - 추후 구현
            _showTermsDialog(text);
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: const Size(40, 30),
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

  // Helper methods
  Future<void> _showSignupCompleteDialog() async {
    await SignupCompleteDialog.show(context, () {
      context.goNamed('map');
    });
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showTermsDialog(String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: const Text('약관 내용이 여기에 표시됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}
