import 'package:flutter/material.dart';

class findIDPW extends StatefulWidget {
  @override
  _findIDPWState createState() => _findIDPWState();
}

class _findIDPWState extends State<findIDPW> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordPhoneController = TextEditingController();
  bool _isPhoneTabSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isPhoneTabSelected ? '아이디 찾기' : '비밀번호 찾기',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Tab buttons
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
                                ? Colors.black
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        '아이디 찾기',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _isPhoneTabSelected
                              ? Colors.black
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
                                ? Colors.black
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        '비밀번호 재설정',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: !_isPhoneTabSelected
                              ? Colors.black
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
          Container(
            height: 1,
            color: Colors.grey[300],
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: _isPhoneTabSelected ? _buildIdFinderTab() : _buildPasswordResetTab(),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 40),

        // Phone number input section
        Text(
          '휴대폰 번호',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 15),

        Row(
          children: [
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    hintText: '휴대폰번호를 입력해주세요.',
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

        SizedBox(height: 30),

        // Confirm button
        Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: Color(0xFFFF8C42), // Orange color
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextButton(
            onPressed: () {
              // Handle confirm action
              print('아이디 찾기 확인 버튼 클릭');
            },
            child: Text(
              '확인',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
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
              child: Text(
                '아이디 찾기에 어려움이 있으시다면 고객센터로 문의 바랍니다.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),

        Spacer(),

        // Bottom indicator
        Center(
          child: Container(
            width: 134,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildPasswordResetTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 40),

        // Email input section
        Text(
          '이메일 아이디',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 15),

        Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: '@ 까지 정확하게 입력해 주세요.',
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
            keyboardType: TextInputType.emailAddress,
          ),
        ),

        SizedBox(height: 30),

        // Phone number input section
        Text(
          '휴대폰 번호',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 15),

        Row(
          children: [
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _passwordPhoneController,
                  decoration: InputDecoration(
                    hintText: '휴대폰번호를 입력해주세요.',
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

        SizedBox(height: 30),

        // Confirm button
        Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: Color(0xFFFF8C42), // Orange color
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextButton(
            onPressed: () {
              // Handle confirm action
              print('비밀번호 재설정 확인 버튼 클릭');
            },
            child: Text(
              '확인',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
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
              child: Text(
                '아이디 찾기에 어려움이 있으시다면 고객센터로 문의 바랍니다.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),

        Spacer(),

        // Bottom indicator
        Center(
          child: Container(
            width: 134,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}