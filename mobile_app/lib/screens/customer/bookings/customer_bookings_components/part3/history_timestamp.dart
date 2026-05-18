import 'package:flutter/material.dart';

class HistoryTimestamp3 extends StatelessWidget {
  final String text;
  const HistoryTimestamp3({required this.text, super.key});

  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey));
}
