import 'package:flutter/material.dart';

class InfoChip extends StatelessWidget {
  final String label;
  const InfoChip({required this.label, super.key});

  @override
  Widget build(BuildContext context) => Chip(label: Text(label));
}
