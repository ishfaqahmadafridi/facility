import 'package:flutter/material.dart';

class InstructionText extends StatelessWidget {
  const InstructionText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      textAlign: TextAlign.center,
    );
  }
}
