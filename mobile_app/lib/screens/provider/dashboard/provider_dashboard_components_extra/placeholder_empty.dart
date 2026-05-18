import 'package:flutter/material.dart';

class PlaceholderEmpty extends StatelessWidget {
  final String message;
  const PlaceholderEmpty({required this.message, super.key});

  @override
  Widget build(BuildContext context) => Center(child: Text(message, style: const TextStyle(color: Colors.grey)));
}
