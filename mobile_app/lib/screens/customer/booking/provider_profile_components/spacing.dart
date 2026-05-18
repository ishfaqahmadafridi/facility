import 'package:flutter/material.dart';

class Spacing extends StatelessWidget {
  final double height;
  const Spacing({this.height = 8, super.key});

  @override
  Widget build(BuildContext context) => SizedBox(height: height);
}
