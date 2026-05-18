import 'package:flutter/material.dart';

class BookingTitle extends StatelessWidget {
  final String text;
  const BookingTitle({required this.text, super.key});

  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold));
}
