import 'package:flutter/material.dart';

class ProvidersListWrapper extends StatelessWidget {
  final List<Widget> children;
  const ProvidersListWrapper({required this.children, super.key});

  @override
  Widget build(BuildContext context) => Column(children: children);
}
