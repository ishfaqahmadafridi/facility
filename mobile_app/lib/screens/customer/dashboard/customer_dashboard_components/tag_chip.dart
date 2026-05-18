import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  final String text;
  const TagChip(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(4)), child: Text(text, style: const TextStyle(fontSize: 10, color: Colors.blue)));
}
