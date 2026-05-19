import 'package:flutter/material.dart';

class MultiPersonalDetails extends StatelessWidget {
  final TextEditingController fullNameCtrl;
  final String gender;
  final ValueChanged<String> onGenderChanged;
  final TextEditingController emergencyCtrl;

  const MultiPersonalDetails({required this.fullNameCtrl, required this.gender, required this.onGenderChanged, required this.emergencyCtrl, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(controller: fullNameCtrl, decoration: const InputDecoration(labelText: 'Full Name')),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          initialValue: gender,
          decoration: const InputDecoration(labelText: 'Gender'),
          items: const [
            DropdownMenuItem(value: 'M', child: Text('Male')),
            DropdownMenuItem(value: 'F', child: Text('Female')),
            DropdownMenuItem(value: 'O', child: Text('Other')),
          ],
          onChanged: (val) => onGenderChanged(val!),
        ),
        const SizedBox(height: 10),
        TextField(controller: emergencyCtrl, decoration: const InputDecoration(labelText: 'Emergency Contact Phone')),
      ],
    );
  }
}
