import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  const CategoryChip({required this.label, super.key});

  @override
  Widget build(BuildContext context) => Chip(
        label: Text(label, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      );
}
