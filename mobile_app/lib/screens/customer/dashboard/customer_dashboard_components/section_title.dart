import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0), child: Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
}
