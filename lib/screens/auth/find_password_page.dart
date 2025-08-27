import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parkourspotkorea/widgets/comfirm_button.dart';

class FindIDPW extends StatefulWidget {
  @override
  _FindIDPWState createState() => _FindIDPWState();
}

class _FindIDPWState extends State<FindIDPW> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordPhoneController =
  TextEditingController();
  bool _isPhoneTabSelected = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Color(0xFFF4F7FE),
      resizeToAvoidBottomInset: true, // 키보드가 올라올 때 화면 크기 조정
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colorScheme.primary),
          onPressed: () {
            context.goNamed('login');
          },
        ),
        title: Text(
          _isPhoneTabSelected ? '아이디 찾기' : '비밀번호 찾기',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPhoneTabSelected = true;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _isPhoneTabSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.tertiary,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        '아이디 찾기',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _isPhoneTabSelected
                              ? Color(0xFF4D4D4D)
                              : Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPhoneTabSelected = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: !_isPhoneTabSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.tertiary,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        '비밀번호 재설정',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: !_isPhoneTabSelected
                              ? Color(0xFF4D4D4D)
                              : Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(height: 1, color: Colors.grey[300]),

          // 스크롤 가능한 콘텐츠 영역
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: _isPhoneTabSelected
                  ? _buildIdFinderTab()
                  : _buildPasswordResetTab(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _passwordPhoneController.dispose();
    super.dispose();
  }

  Widget _buildIdFinderTab() {
    final colorTheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // 필요한 만큼만 공간 차지
      children: [
        SizedBox(height: 30),

        // Phone number input section
        Text('휴대폰 번호', style: Theme.of(context).textTheme.bodySmall),

        SizedBox(height: 15),

        Row(
          children: [
            Expanded(
              child: Container(
                height: 50,
                child: TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    hintText: '010-1234-5678',
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
            ),
            SizedBox(width: 10),

            // Verification button
            Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  '인증번호',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 20),

        // Confirm button
        ComfirmButton(
          text: '인증 요청',
          onPressed: () {
            print('확인 버튼 클릭');
            context.go('');
          },
        ),

        SizedBox(height: 20),

        // Information text
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 4,
              height: 4,
              margin: EdgeInsets.only(top: 8, right: 8),
              decoration: BoxDecoration(
                color: Colors.grey[600],
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(text: '아이디 찾기에 어려움이 있으시다면 '),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () {
                          // 고객센터 페이지로 이동
                          context.goNamed('customerService');
                        },
                        child: Text(
                          '고객센터',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                    TextSpan(text: '로 문의 바랍니다.'),
                  ],
                ),
              ),
            ),
          ],
        ),

        // 추가 여백으로 스크롤 공간 확보
        SizedBox(height: 100),
      ],
    );
  }

  Widget _buildPasswordResetTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // 필요한 만큼만 공간 차지
      children: [
        SizedBox(height: 20),

        // Email input section
        Text(
          '이메일 아이디',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Color(0xFF4D4D4D)),
        ),

        SizedBox(height: 15),

        Container(
          height: 50,
          child: TextField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: '@ 까지 정확하게 입력해 주세요.',
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ),

        SizedBox(height: 30),

        // Phone number input section



        // Confirm button
        ComfirmButton(
      text: '비밀번호 재설정 이메일 보내기'
    ,onPressed: () {
          context.goNamed('customerService');
        },),

        SizedBox(height: 20),

        // Information text
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 4,
              height: 4,
              margin: EdgeInsets.only(top: 8, right: 8),
              decoration: BoxDecoration(
                color: Colors.grey[600],
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(text: '아이디 찾기에 어려움이 있으시다면 '),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () {
                          // 고객센터 페이지로 이동
                          context.goNamed('customerService');
                        },
                        child: Text(
                          '고객센터',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                    TextSpan(text: '로 문의 바랍니다.'),
                  ],
                ),
              ),
            ),
          ],
        ),
        // 추가 여백으로 스크롤 공간 확보
        SizedBox(height: 100),
      ],
    );
  }
}