import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parkourspotkorea/theme/app_colors.dart';

class AboutCreatorPage extends StatelessWidget {
  const AboutCreatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BrandColors.c900,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: BrandColors.txtWhite,
          onPressed: () {
            context.goNamed('profile');
          },
        ),

        title: Text('만든이 정보'),
      ),
      body: Stack(
        children: [
          // 배경 이미지
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/images/loginPage-background.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // 기존 컨텐츠
          SingleChildScrollView(
            padding: EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 60),
                Image.asset(
                  'assets/images/about-creator.png',
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
