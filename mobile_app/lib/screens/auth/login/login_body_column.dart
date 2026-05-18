import 'package:flutter/material.dart';

class LoginBodyColumn extends StatelessWidget {
  final List<Widget> children;
  const LoginBodyColumn({required this.children, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}
