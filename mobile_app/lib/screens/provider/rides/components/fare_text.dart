import 'package:flutter/material.dart';

class FareText extends StatelessWidget {
  final num fare;
  const FareText({required this.fare, super.key});

  @override
  Widget build(BuildContext context) => Text('Rs ${fare.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 18));
}
