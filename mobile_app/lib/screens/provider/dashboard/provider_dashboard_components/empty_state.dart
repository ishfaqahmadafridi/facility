import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String message;
  const EmptyState({required this.message, super.key});

  @override
  Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(32.0), child: Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.grey))));
}
