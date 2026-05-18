import 'package:flutter/material.dart';

class RoleIcon extends StatelessWidget {
  final IconData icon;
  final bool highlighted;

  const RoleIcon({required this.icon, this.highlighted = false, super.key});

  @override
  Widget build(BuildContext context) => Icon(icon, size: 40, color: highlighted ? Colors.blue : Colors.grey);
}
