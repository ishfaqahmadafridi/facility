import 'package:flutter/material.dart';

class DropoffRow extends StatelessWidget {
  final String address;
  const DropoffRow({required this.address, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.location_on, color: Colors.red, size: 20),
        const SizedBox(width: 8),
        Expanded(child: Text(address)),
      ],
    );
  }
}
