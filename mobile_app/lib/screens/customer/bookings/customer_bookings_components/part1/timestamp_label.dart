import 'package:flutter/material.dart';

class TimestampLabel1 extends StatelessWidget {
  final String text;
  const TimestampLabel1({required this.text, super.key});

  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey));
}
