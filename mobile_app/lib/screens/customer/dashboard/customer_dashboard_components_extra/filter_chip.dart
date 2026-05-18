import 'package:flutter/material.dart';

class FilterChipExtra extends StatelessWidget {
  final String label;
  const FilterChipExtra(this.label, {super.key});

  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade300)), child: Text(label));
}
