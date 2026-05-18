import 'package:flutter/material.dart';

class MultiStepTitle extends StatelessWidget {
  final String title;
  const MultiStepTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) => Text(title, style: const TextStyle(fontWeight: FontWeight.bold));
}
