import 'package:flutter/material.dart';

class RoleTitle extends StatelessWidget {
  final String text;
  final bool highlighted;

  const RoleTitle({required this.text, this.highlighted = false, super.key});

  @override
  Widget build(BuildContext context) => Text(text, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: highlighted ? Colors.blue : Colors.black));
}
