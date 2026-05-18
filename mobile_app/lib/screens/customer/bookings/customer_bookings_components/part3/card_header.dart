import 'package:flutter/material.dart';

class CardHeader3 extends StatelessWidget {
  final String title;
  const CardHeader3({required this.title, super.key});

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)));
}
