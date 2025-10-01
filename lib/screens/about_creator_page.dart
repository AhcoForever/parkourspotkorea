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
    );
  }
}
