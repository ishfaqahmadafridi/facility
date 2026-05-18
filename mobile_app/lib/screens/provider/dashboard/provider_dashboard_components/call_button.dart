import 'package:flutter/material.dart';

class CallButton extends StatelessWidget {
  final VoidCallback onPressed;
  const CallButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) => IconButton(icon: const Icon(Icons.call_outlined), onPressed: onPressed);
}
