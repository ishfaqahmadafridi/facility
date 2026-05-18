import 'package:flutter/material.dart';

class HistoryMeta3 extends StatelessWidget {
  final String text;
  const HistoryMeta3({required this.text, super.key});

  @override
  Widget build(BuildContext context) => Row(children: [Text(text), const SizedBox(width: 8)]);
}
