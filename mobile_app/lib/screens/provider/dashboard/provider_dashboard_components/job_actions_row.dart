import 'package:flutter/material.dart';

class JobActionsRow extends StatelessWidget {
  final VoidCallback onAccept;
  const JobActionsRow({required this.onAccept, super.key});

  @override
  Widget build(BuildContext context) => SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white), onPressed: onAccept, child: const Text('Accept Job')));
}
