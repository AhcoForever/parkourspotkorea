import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parkourspotkorea/widgets/background_wrapper.dart';
import 'package:provider/provider.dart';

import '../../model/signup.dart';
import '../../viewmodel/signup_viewmodel.dart';
import '../../widgets/back_button.dart';
import '../../widgets/dialogs/signup_complete_dialog.dart';
import '../../theme/app_colors.dart';

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
          backgroundColor: BrandColors.c900,
          appBar: AppBar(
            backgroundColor: BrandColors.c900,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_sharp,
                size: 20,
                color: BrandColors.txtWhite,
              ),
              onPressed: () => smartBack(context),
            ),
            title: const Text(
              '회원가입',
              style: TextStyle(
                color: BrandColors.txtWhite,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: BackgroundWrapper(
            child: Stack(
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
                          const SizedBox(height: 48),

                          _buildTermsSection(viewModel),
                          const SizedBox(height: 25),

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
                    color: BrandColors.c900.withOpacity(0.8),
                    child: Center(
                      child: CircularProgressIndicator(color: BrandColors.c500),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmailField(SignupViewModel viewModel) {
    // 이메일 유효성 검사 로직
    final emailText = _emailController.text.trim();
    final hasError = viewModel.validationErrors['email'] != null;
    final isValidEmail =
        emailText.isNotEmpty &&
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailText);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 40,),
        _buildLabel('이메일 아이디', true),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _emailController,
          hintText: 'parkourspot@gmail.com',
          keyboardType: TextInputType.emailAddress,
          errorText: viewModel.validationErrors['email'],
          successText: !hasError && isValidEmail ? '사용할 수 있는 이메일입니다.' : null,
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
SizedBox(height: 15),
        _buildCheckboxRowWithButton(
          '[필수] 만 14세 이상입니다.',
          terms.isAdult,
          (value) => viewModel.updateTermsAgreement(isAdult: value),
        ),

        _buildCheckboxRowWithButton(
          '[필수] 서비스 이용약관',
          terms.agreeToService,
          (value) => viewModel.updateTermsAgreement(agreeToService: value),
        ),

        _buildCheckboxRowWithButton(
          '[필수] 개인정보 수집/이용동의',
          terms.agreeToPrivacy,
          (value) => viewModel.updateTermsAgreement(agreeToPrivacy: value),
        ),

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
              ? BrandColors.c500
              : BrandColors.c700,
          foregroundColor: BrandColors.txtWhite,

          elevation: 0,
        ),
        child: viewModel.isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    BrandColors.txtWhite,
                  ),
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
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: BrandColors.txt30,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (isRequired)
          const Text(
            ' *',
            style: TextStyle(fontSize: 14, color: StrokeColors.error),
          ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? errorText,
    String? successText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: const TextStyle(color: BrandColors.txt30),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: BrandColors.txt500, fontSize: 14),
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
              borderSide: BorderSide(
                color: successText != null
                    ? StrokeColors.success
                    : StrokeColors.defaultStroke,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: successText != null
                    ? StrokeColors.success
                    : BrandColors.c500,
                width: 2,
              ),
            ),
            errorText: errorText,
            errorStyle: const TextStyle(
              fontSize: 12,
              color: StrokeColors.error,
            ),
          ),
        ),
        if (successText != null && errorText == null) ...[
          const SizedBox(height: 4),
          Text(
            successText,
            style: const TextStyle(fontSize: 12, color: StrokeColors.success),
          ),
        ],
      ],
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
        GestureDetector(
          onTap: () => onChanged(!value),
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: value ? BrandColors.c500 : Colors.transparent,
              border: Border.all(
                color: value ? BrandColors.c500 : BrandColors.normal,
                width: 2,
              ),
            ),
            child: value
                ? const Icon(
                    Icons.check,
                    size: 16,
                    color: BrandColors.txtWhite,
                  )
                : null,
          ),
        ),

        const SizedBox(width: 18),

        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.normal,
              color: BrandColors.txt30,
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
        GestureDetector(
          onTap: () => onChanged(!value),
          child: Icon(
            Icons.check,
            size: 20,
            color: value ? BrandColors.c500 : StrokeColors.defaultStroke,
          ),
        ),
        const SizedBox(width:24),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: BrandColors.txt500,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            // TODO: 약관 보기 기능 구현
            _showTermsDialog(text);
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: const Size(40, 30),
          ),
          child: const Text(
            '보기',
            style: TextStyle(
              fontSize: 12,
              color: BrandColors.txt700,
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
      context.goNamed('nickname');
    });
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: StrokeColors.error),
    );
  }

  void _showTermsDialog(String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: BrandColors.c800,
        title: Text(title, style: const TextStyle(color: BrandColors.txt30)),
        content: const Text(
          '약관 내용이 여기에 표시됩니다.',
          style: TextStyle(color: BrandColors.txt300),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인', style: TextStyle(color: BrandColors.c500)),
          ),
        ],
      ),
    );
  }
}
