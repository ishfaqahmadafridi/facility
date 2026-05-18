import 'package:flutter/material.dart';

class MultiSetLocationButton extends StatelessWidget {
  final VoidCallback onSet;
  const MultiSetLocationButton({required this.onSet, super.key});

  @override
  Widget build(BuildContext context) => ElevatedButton.icon(onPressed: onSet, icon: const Icon(Icons.location_on), label: const Text('Set Location (GPS)'));
}
