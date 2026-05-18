import 'package:flutter/material.dart';

class WomenSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const WomenSwitch({required this.value, required this.onChanged, super.key});

  @override
  Widget build(BuildContext context) => SwitchListTile(contentPadding: EdgeInsets.zero, value: value, activeColor: Colors.pink, title: const Text('Women safety filter'), subtitle: const Text('Female customers can request female providers only.'), onChanged: onChanged);
}
