import 'package:flutter/material.dart';

class DescriptionInput extends StatelessWidget {
  final TextEditingController controller;
  const DescriptionInput({required this.controller, super.key});

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        maxLines: 3,
        decoration: InputDecoration(hintText: 'Describe what needs to be done...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
      );
}
