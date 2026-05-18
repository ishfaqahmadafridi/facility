import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String message;
  const EmptyState({required this.message, super.key});

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.all(32.0), child: Center(child: Text(message, style: const TextStyle(color: Colors.grey, fontSize: 16))));
}
