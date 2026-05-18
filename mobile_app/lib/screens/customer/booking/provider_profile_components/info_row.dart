import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const InfoRow({required this.icon, required this.text, super.key});

  @override
  Widget build(BuildContext context) => Row(
        children: [Icon(icon, color: Colors.grey), const SizedBox(width: 8), Text(text)],
      );
}
