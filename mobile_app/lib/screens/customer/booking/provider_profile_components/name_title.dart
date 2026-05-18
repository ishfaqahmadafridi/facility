import 'package:flutter/material.dart';

class NameTitle extends StatelessWidget {
  final String name;
  const NameTitle({required this.name, super.key});

  @override
  Widget build(BuildContext context) => Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
}
