import 'package:flutter/material.dart';

class EscrowInfoCard extends StatelessWidget {
  final String text;
  const EscrowInfoCard({required this.text, super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.blue.shade200)),
        child: Row(children: [const Icon(Icons.security, color: Colors.blue), const SizedBox(width: 12), Expanded(child: Text(text, style: const TextStyle(color: Colors.blue)))]),
      );
}
