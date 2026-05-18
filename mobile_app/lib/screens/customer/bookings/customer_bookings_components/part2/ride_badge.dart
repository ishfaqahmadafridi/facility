import 'package:flutter/material.dart';

class RideBadge2 extends StatelessWidget {
  final String text;
  const RideBadge2({required this.text, super.key});

  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)), child: Text(text));
}
