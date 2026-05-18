import 'package:flutter/material.dart';

class PhoneInfo extends StatelessWidget {
  const PhoneInfo({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Code sent to $phoneNumber',
      style: const TextStyle(fontSize: 16, color: Colors.grey),
    );
  }
}
