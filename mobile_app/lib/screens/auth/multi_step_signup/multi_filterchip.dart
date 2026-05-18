import 'package:flutter/material.dart';

class MultiFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const MultiFilterChip({required this.label, required this.selected, required this.onSelected, super.key});

  @override
  Widget build(BuildContext context) => FilterChip(label: Text(label), selected: selected, onSelected: onSelected);
}
