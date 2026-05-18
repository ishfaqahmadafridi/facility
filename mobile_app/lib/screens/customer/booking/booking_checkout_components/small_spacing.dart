import 'package:flutter/material.dart';

class SmallSpacing extends StatelessWidget {
  final double height;
  const SmallSpacing({this.height = 8, super.key});

  @override
  Widget build(BuildContext context) => SizedBox(height: height);
}
