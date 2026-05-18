import 'package:flutter/material.dart';

class WelcomeSubtitle extends StatelessWidget {
  const WelcomeSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Enter your phone number to continue',
      style: TextStyle(fontSize: 16, color: Colors.grey),
    );
  }
}
