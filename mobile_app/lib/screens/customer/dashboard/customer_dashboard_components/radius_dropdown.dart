import 'package:flutter/material.dart';

class RadiusDropdown extends StatelessWidget {
  final double value;
  final ValueChanged<double?> onChanged;
  const RadiusDropdown({required this.value, required this.onChanged, super.key});

  @override
  Widget build(BuildContext context) => DropdownButton<double>(value: value, underline: Container(), items: const [DropdownMenuItem(value: 5.0, child: Text('5 km')), DropdownMenuItem(value: 10.0, child: Text('10 km')), DropdownMenuItem(value: 20.0, child: Text('20 km'))], onChanged: onChanged);
}
