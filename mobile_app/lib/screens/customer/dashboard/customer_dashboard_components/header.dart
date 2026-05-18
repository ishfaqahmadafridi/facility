import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  final String title;
  const DashboardHeader({this.title = 'What do you need help with?', super.key});

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.all(16.0), child: Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)));
}
