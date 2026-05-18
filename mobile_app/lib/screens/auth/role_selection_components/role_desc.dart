import 'package:flutter/material.dart';

class RoleDesc extends StatelessWidget {
  final String text;

  const RoleDesc({required this.text, super.key});

  @override
  Widget build(BuildContext context) => Text(text, style: TextStyle(fontSize: 14, color: Colors.grey.shade600));
}
