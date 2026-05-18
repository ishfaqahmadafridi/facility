import 'package:flutter/material.dart';

class RideMeta2 extends StatelessWidget {
  final String text;
  const RideMeta2({required this.text, super.key});

  @override
  Widget build(BuildContext context) => Row(children: [Text(text), const SizedBox(width: 8)]);
}
