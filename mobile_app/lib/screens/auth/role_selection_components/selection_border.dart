import 'package:flutter/material.dart';

class SelectionBorder extends StatelessWidget {
  final bool selected;
  final Widget child;

  const SelectionBorder({required this.selected, required this.child, super.key});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          border: Border.all(color: selected ? Colors.blue : Colors.grey.shade300, width: selected ? 2 : 1),
          borderRadius: BorderRadius.circular(12),
          color: selected ? Colors.blue.shade50 : Colors.white,
        ),
        child: child,
      );
}
