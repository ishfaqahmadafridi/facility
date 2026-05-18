import 'package:flutter/material.dart';

class FooterLinks extends StatelessWidget {
  const FooterLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(onPressed: () {}, child: const Text('Help')),
        TextButton(onPressed: () {}, child: const Text('Contact')),
      ],
    );
  }
}
