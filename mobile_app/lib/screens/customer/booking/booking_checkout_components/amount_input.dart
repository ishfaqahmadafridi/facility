import 'package:flutter/material.dart';

class AmountInput extends StatelessWidget {
  final TextEditingController controller;
  const AmountInput({required this.controller, super.key});

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(prefixText: 'Rs. ', hintText: 'Enter amount to hold in escrow', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
      );
}
