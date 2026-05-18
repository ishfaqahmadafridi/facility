import 'package:flutter/material.dart';

class MultiRoleSelection extends StatelessWidget {
  final String selectedRole;
  final ValueChanged<String> onChanged;

  const MultiRoleSelection({required this.selectedRole, required this.onChanged, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile(
          title: const Text('Customer'),
          subtitle: const Text('I want to hire professionals'),
          value: 'CUSTOMER',
          groupValue: selectedRole,
          onChanged: (val) => onChanged(val.toString()),
        ),
        RadioListTile(
          title: const Text('Service Provider'),
          subtitle: const Text('I want to offer my services'),
          value: 'PROVIDER',
          groupValue: selectedRole,
          onChanged: (val) => onChanged(val.toString()),
        ),
      ],
    );
  }
}
