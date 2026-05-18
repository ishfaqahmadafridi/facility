import 'package:flutter/material.dart';

class MultiExperienceField extends StatelessWidget {
  final TextEditingController controller;
  const MultiExperienceField({required this.controller, super.key});

  @override
  Widget build(BuildContext context) => TextField(controller: controller, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Years of Experience'));
}
