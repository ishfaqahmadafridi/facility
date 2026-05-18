import 'package:flutter/material.dart';

class ScaffoldPadding extends StatelessWidget {
  const ScaffoldPadding({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(24.0), child: child);
  }
}
