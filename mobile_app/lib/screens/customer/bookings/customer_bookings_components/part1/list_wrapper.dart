import 'package:flutter/material.dart';

class ListWrapper1 extends StatelessWidget {
  final List<Widget> children;
  const ListWrapper1({required this.children, super.key});

  @override
  Widget build(BuildContext context) => Column(children: children);
}
