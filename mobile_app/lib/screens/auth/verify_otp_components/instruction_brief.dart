import 'package:flutter/material.dart';

class InstructionBrief extends StatelessWidget {
  const InstructionBrief({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14));
  }
}
