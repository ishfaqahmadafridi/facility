import 'package:flutter/material.dart';

class JobTag extends StatelessWidget {
  final String label;
  const JobTag({required this.label, super.key});

  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(6)), child: Text(label));
}
