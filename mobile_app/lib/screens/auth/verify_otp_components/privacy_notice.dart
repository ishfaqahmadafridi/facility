import 'package:flutter/material.dart';

class PrivacyNotice extends StatelessWidget {
  const PrivacyNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('By continuing you agree to our Terms & Privacy.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey));
  }
}
