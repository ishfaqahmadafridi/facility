import 'package:flutter/material.dart';

class RideListWrapper2 extends StatelessWidget {
  final List<Widget> children;
  const RideListWrapper2({required this.children, super.key});

  @override
  Widget build(BuildContext context) => Column(children: children);
}
