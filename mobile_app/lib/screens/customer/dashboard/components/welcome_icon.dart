import 'package:flutter/material.dart';

class WelcomeIcon extends StatelessWidget {
  const WelcomeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.person,
      size: 80,
      color: Colors.blueAccent,
    );
  }
}
