import 'package:flutter/material.dart';

class CounterOfferButton extends StatelessWidget {
  final VoidCallback onPressed;
  const CounterOfferButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(onPressed: onPressed, child: const Text('Counter Offer'));
  }
}
