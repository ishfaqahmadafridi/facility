import 'package:flutter/material.dart';

class RideTitle extends StatelessWidget {
  final String text;
  const RideTitle({required this.text, super.key});

  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18));
}
