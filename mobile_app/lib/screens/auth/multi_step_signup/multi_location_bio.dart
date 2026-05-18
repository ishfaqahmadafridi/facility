import 'package:flutter/material.dart';

class MultiLocationBio extends StatelessWidget {
  final VoidCallback onSetLocation;
  final TextEditingController bioCtrl;

  const MultiLocationBio({required this.onSetLocation, required this.bioCtrl, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(onPressed: onSetLocation, icon: const Icon(Icons.location_on), label: const Text('Set Location (GPS)')),
        const SizedBox(height: 15),
        TextField(controller: bioCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'Short Bio about yourself')),
      ],
    );
  }
}
