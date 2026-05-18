import 'package:flutter/material.dart';

class ProviderSubtitle extends StatelessWidget {
  final String text;
  const ProviderSubtitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(fontSize: 12));
}
