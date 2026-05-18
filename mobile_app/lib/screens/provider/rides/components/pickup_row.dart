import 'package:flutter/material.dart';

class PickupRow extends StatelessWidget {
  final String address;
  const PickupRow({required this.address, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.my_location, color: Colors.blue, size: 20),
        const SizedBox(width: 8),
        Expanded(child: Text(address)),
      ],
    );
  }
}
