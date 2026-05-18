import 'package:flutter/material.dart';

class TimestampLabel extends StatelessWidget {
  final String text;
  const TimestampLabel({required this.text, super.key});

  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey));
}
