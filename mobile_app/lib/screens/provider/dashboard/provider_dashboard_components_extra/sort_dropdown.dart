import 'package:flutter/material.dart';

class SortDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;
  const SortDropdown({required this.value, required this.onChanged, super.key});

  @override
  Widget build(BuildContext context) => DropdownButton<String>(value: value, items: const [DropdownMenuItem(value: 'new', child: Text('Newest')), DropdownMenuItem(value: 'near', child: Text('Nearest'))], onChanged: onChanged);
}
