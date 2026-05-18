import 'package:flutter/material.dart';

class DashboardSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  const DashboardSearchBar({this.onChanged, super.key});

  @override
  Widget build(BuildContext context) => TextField(decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search jobs'), onChanged: onChanged);
}
