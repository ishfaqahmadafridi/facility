import 'package:flutter/material.dart';
import '../components/chips_wrap.dart' as base;

class ChipsWrap extends StatelessWidget {
  final List<Widget> children;
  const ChipsWrap({required this.children, super.key});

  @override
  Widget build(BuildContext context) => base.ChipsWrap(children: children);
}
