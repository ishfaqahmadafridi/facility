import 'package:flutter/material.dart';

class PagePadding extends StatelessWidget {
  final Widget child;
  const PagePadding({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: child,
    );
  }
}
