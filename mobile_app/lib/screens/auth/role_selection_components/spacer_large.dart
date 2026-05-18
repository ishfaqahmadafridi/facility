import 'package:flutter/material.dart';

class SpacerLarge extends StatelessWidget {
  final double height;
  const SpacerLarge({this.height = 40, super.key});

  @override
  Widget build(BuildContext context) => SizedBox(height: height);
}
