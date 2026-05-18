import 'package:flutter/material.dart';
import '../components/card_padding.dart' as base;

class CardPadding extends StatelessWidget {
  final Widget child;
  const CardPadding({required this.child, super.key});

  @override
  Widget build(BuildContext context) => base.CardPadding(child: child);
}
