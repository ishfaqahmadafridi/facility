import 'package:flutter/material.dart';

class CardPadding extends StatelessWidget {
  final Widget child;
  const CardPadding({required this.child, super.key});

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.all(16), child: child);
}
