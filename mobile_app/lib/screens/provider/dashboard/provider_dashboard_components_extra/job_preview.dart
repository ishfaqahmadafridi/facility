import 'package:flutter/material.dart';

class JobPreview extends StatelessWidget {
  final String title;
  final String subtitle;
  const JobPreview({required this.title, required this.subtitle, super.key});

  @override
  Widget build(BuildContext context) => ListTile(title: Text(title), subtitle: Text(subtitle));
}
