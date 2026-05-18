import 'package:flutter/material.dart';

class CardHeader1 extends StatelessWidget {
  final String title;
  const CardHeader1({required this.title, super.key});

  @override
  Widget build(BuildContext context) => Text(title, style: const TextStyle(fontWeight: FontWeight.bold));
}
