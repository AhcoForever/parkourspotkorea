import 'package:flutter/material.dart';
import 'package:parkourspotkorea/screens/customer_service_page.dart';
import 'package:parkourspotkorea/screens/findIDPW_page.dart';
import 'package:parkourspotkorea/screens/login_page.dart';
import 'package:parkourspotkorea/screens/signup_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parkour Finder',
      theme: ThemeData(
      ),
      home: findIDPW(),
      //home: CustomerServicePage(),
      //home: SignUpPage(),
      //home: SignupCompleteDialog(),
      //home: const LoginPage()
    );
  }
}

