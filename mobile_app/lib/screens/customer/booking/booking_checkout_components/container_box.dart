import 'package:flutter/material.dart';

class ContainerBox extends StatelessWidget {
  final Widget child;
  final double? height;
  const ContainerBox({required this.child, this.height, super.key});

  @override
  Widget build(BuildContext context) => Container(height: height, width: double.infinity, decoration: BoxDecoration(color: Colors.grey.shade300), child: child);
}
