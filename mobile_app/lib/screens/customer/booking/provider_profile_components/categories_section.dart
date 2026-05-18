import 'package:flutter/material.dart';
import 'category_chip.dart';

class CategoriesSection extends StatelessWidget {
  final List<dynamic> categories;
  const CategoriesSection({required this.categories, super.key});

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 8,
        children: categories.map((c) => CategoryChip(label: c.toString())).toList(),
      );
}
