import 'package:flutter/material.dart';
import '../components/fare_text.dart' as base;

class FareText extends StatelessWidget {
  final num fare;
  const FareText({required this.fare, super.key});

  @override
  Widget build(BuildContext context) => base.FareText(fare: fare);
}
