import 'package:flutter/material.dart';

class MultiStepWrapper extends StatelessWidget {
  final Widget child;
  const MultiStepWrapper({required this.child, super.key});

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.all(8.0), child: child);
}
