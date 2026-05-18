import 'package:flutter/material.dart';

class ToggleButtonCustom extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const ToggleButtonCustom({required this.value, required this.onChanged, super.key});

  @override
  Widget build(BuildContext context) => Switch(value: value, onChanged: onChanged);
}
