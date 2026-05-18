import 'package:flutter/material.dart';

class ProviderTitle extends StatelessWidget {
  final String title;
  const ProviderTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) => Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16));
}
