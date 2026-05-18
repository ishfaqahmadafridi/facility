import 'package:flutter/material.dart';

class MetaRow1 extends StatelessWidget {
  final String text;
  const MetaRow1({required this.text, super.key});

  @override
  Widget build(BuildContext context) => Row(children: [Text(text), const SizedBox(width: 8)]);
}
