import 'package:flutter/material.dart';

class SmallSpacing1 extends StatelessWidget {
  final double height;
  const SmallSpacing1({this.height = 8, super.key});

  @override
  Widget build(BuildContext context) => SizedBox(height: height);
}
