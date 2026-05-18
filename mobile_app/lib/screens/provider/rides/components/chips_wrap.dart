import 'package:flutter/material.dart';

class ChipsWrap extends StatelessWidget {
  final List<Widget> children;
  const ChipsWrap({required this.children, super.key});

  @override
  Widget build(BuildContext context) => Wrap(spacing: 8, runSpacing: 8, children: children);
}
