import 'package:flutter/material.dart';

class FareField extends StatelessWidget {
  final TextEditingController controller;

  const FareField({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        hintText: 'Enter suggested fare',
        prefixText: 'PKR ',
      ),
    );
  }
}
