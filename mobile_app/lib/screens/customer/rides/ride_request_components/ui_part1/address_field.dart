import 'package:flutter/material.dart';

class AddressField extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final TextEditingController controller;
  final String hintText;

  const AddressField({required this.title, required this.icon, required this.color, required this.controller, required this.hintText, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon, color: color),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}
