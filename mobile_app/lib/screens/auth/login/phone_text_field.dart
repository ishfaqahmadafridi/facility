import 'package:flutter/material.dart';

class PhoneTextField extends StatelessWidget {
  final TextEditingController controller;
  const PhoneTextField({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'Phone Number',
        hintText: '+92 300 1234567',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: const Icon(Icons.phone),
      ),
    );
  }
}
