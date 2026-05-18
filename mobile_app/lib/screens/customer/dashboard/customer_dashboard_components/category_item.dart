import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  const CategoryItem({required this.title, required this.icon, this.selected = false, super.key});

  @override
  Widget build(BuildContext context) => Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 40, color: selected ? Colors.white : Colors.blue), const SizedBox(height: 8), Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: selected ? Colors.white : Colors.black87))]);
}
