import 'package:flutter/material.dart';

class MultiBioField extends StatelessWidget {
  final TextEditingController controller;
  const MultiBioField({required this.controller, super.key});

  @override
  Widget build(BuildContext context) => TextField(controller: controller, maxLines: 3, decoration: const InputDecoration(labelText: 'Short Bio about yourself'));
}
