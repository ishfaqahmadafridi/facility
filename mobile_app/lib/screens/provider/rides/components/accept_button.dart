import 'package:flutter/material.dart';

class AcceptButton extends StatelessWidget {
  final VoidCallback onPressed;
  const AcceptButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: const Text('Accept'));
  }
}
