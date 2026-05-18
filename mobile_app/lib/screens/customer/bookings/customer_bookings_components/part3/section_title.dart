import 'package:flutter/material.dart';

class SectionTitle3 extends StatelessWidget {
  final String text;
  const SectionTitle3(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 8.0), child: Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
}
