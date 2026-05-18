import 'package:flutter/material.dart';

class FilterRow extends StatelessWidget {
  final List<Widget> children;
  const FilterRow({required this.children, super.key});

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Row(children: children));
}
