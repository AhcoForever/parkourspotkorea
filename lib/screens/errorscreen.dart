import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Errorscreen extends StatelessWidget {
  final String message;
  const Errorscreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("오류 발생")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("뒤로가기"),
            ),
          ],
        ),
      ),
    );
  }
}
