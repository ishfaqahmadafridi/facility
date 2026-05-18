import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  final String about;
  const AboutSection({required this.about, super.key});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(about, style: const TextStyle(fontSize: 16)),
        ],
      );
}
