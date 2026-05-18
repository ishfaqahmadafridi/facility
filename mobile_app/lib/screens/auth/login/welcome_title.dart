import 'package:flutter/material.dart';

class WelcomeTitle extends StatelessWidget {
  const WelcomeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Welcome to KamKaro',
      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    );
  }
}
