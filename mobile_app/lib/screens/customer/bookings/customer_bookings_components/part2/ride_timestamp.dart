import 'package:flutter/material.dart';

class RideTimestamp2 extends StatelessWidget {
  final String text;
  const RideTimestamp2({required this.text, super.key});

  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey));
}
