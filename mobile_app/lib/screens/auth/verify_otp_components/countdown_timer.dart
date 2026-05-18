import 'package:flutter/material.dart';

class CountdownTimer extends StatelessWidget {
  const CountdownTimer({super.key, required this.secondsLeft});

  final int secondsLeft;

  @override
  Widget build(BuildContext context) {
    final minutes = secondsLeft ~/ 60;
    final seconds = secondsLeft % 60;
    final text = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    return Text(text, style: const TextStyle(color: Colors.grey));
  }
}
