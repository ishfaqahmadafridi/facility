import 'package:flutter/material.dart';

class HistoryCard3 extends StatelessWidget {
  final Map<String, dynamic> item;
  const HistoryCard3({required this.item, super.key});

  @override
  Widget build(BuildContext context) => Card(margin: const EdgeInsets.only(bottom: 12), child: ListTile(title: Text(item['title'] ?? 'History item'), subtitle: Text(item['subtitle'] ?? '')));
}
