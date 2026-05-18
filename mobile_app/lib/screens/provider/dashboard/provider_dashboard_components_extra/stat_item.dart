import 'package:flutter/material.dart';

class StatItem extends StatelessWidget {
  final String label;
  final String value;
  const StatItem({required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) => Column(children: [Text(value, style: const TextStyle(fontWeight: FontWeight.bold)), Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey))]);
}
