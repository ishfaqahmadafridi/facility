import 'package:flutter/material.dart';

class HistoryEmpty3 extends StatelessWidget {
  final String message;
  const HistoryEmpty3({required this.message, super.key});

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.all(16), child: Text(message, style: const TextStyle(color: Colors.grey)));
}
