import 'package:flutter/material.dart';

class FilterChipCustom extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  const FilterChipCustom({required this.label, this.selected = false, this.onTap, super.key});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), decoration: BoxDecoration(color: selected ? Colors.blue : Colors.grey.shade200, borderRadius: BorderRadius.circular(8)), child: Text(label, style: TextStyle(color: selected ? Colors.white : Colors.black))),
      );
}
