import 'package:flutter/material.dart';

class MetaIcon extends StatelessWidget {
  final IconData icon;
  const MetaIcon({required this.icon, super.key});

  @override
  Widget build(BuildContext context) => Icon(icon, size: 14, color: Colors.grey.shade700);
}
