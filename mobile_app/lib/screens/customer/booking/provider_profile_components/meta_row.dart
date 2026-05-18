import 'package:flutter/material.dart';

class MetaRow extends StatelessWidget {
  final String location;
  final String availability;
  const MetaRow({required this.location, required this.availability, super.key});

  @override
  Widget build(BuildContext context) => Row(
        children: [Text(location), const SizedBox(width: 12), Text(availability)],
      );
}
