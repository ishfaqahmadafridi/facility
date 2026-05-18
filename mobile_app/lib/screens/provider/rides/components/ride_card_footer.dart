import 'package:flutter/material.dart';

class RideCardFooter extends StatelessWidget {
  final Widget child;
  const RideCardFooter({required this.child, super.key});

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(top: 12.0), child: child);
}
