import 'package:flutter/material.dart';
import 'multi_filterchip.dart';

class MultiCategoriesWrap extends StatelessWidget {
  final List<String> available;
  final List<String> selected;
  final void Function(String, bool) onToggle;

  const MultiCategoriesWrap({required this.available, required this.selected, required this.onToggle, super.key});

  @override
  Widget build(BuildContext context) => Wrap(spacing: 8.0, children: available.map((cat) => MultiFilterChip(label: cat, selected: selected.contains(cat), onSelected: (sel) => onToggle(cat, sel))).toList());
}
