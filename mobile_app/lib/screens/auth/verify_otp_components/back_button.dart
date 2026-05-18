import 'package:flutter/material.dart';

class SimpleBackButton extends StatelessWidget {
  const SimpleBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.of(context).maybePop(),
    );
  }
}
