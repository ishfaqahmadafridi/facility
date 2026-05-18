import 'package:flutter/material.dart';

class StatsSummary extends StatelessWidget {
  final List<Widget> items;
  const StatsSummary({required this.items, super.key});

  @override
  Widget build(BuildContext context) => Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: items);
}
