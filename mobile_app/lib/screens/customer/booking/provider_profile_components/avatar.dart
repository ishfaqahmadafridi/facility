import 'package:flutter/material.dart';

class ProviderAvatar extends StatelessWidget {
  final double radius;
  const ProviderAvatar({this.radius = 50, super.key});

  @override
  Widget build(BuildContext context) => CircleAvatar(
        radius: radius,
        backgroundColor: Colors.blue.shade100,
        child: const Icon(Icons.person, size: 50, color: Colors.blue),
      );
}
