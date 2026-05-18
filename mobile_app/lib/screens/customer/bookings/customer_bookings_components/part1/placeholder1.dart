import 'package:flutter/material.dart';

class Placeholder1 extends StatelessWidget {
  final String text;
  const Placeholder1({required this.text, super.key});

  @override
  Widget build(BuildContext context) => Text(text);
}
