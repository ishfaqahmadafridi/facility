import 'package:flutter/material.dart';

class MultiTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int maxLines;

  const MultiTextField({required this.controller, required this.label, this.maxLines = 1, super.key});

  @override
  Widget build(BuildContext context) => TextField(controller: controller, maxLines: maxLines, decoration: InputDecoration(labelText: label));
}
