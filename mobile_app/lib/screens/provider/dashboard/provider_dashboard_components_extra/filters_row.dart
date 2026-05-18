import 'package:flutter/material.dart';

class FiltersRow extends StatelessWidget {
  final List<Widget> children;
  const FiltersRow({required this.children, super.key});

  @override
  Widget build(BuildContext context) => Row(children: children);
}
