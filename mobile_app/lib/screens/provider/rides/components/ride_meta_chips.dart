import 'package:flutter/material.dart';
import 'customer_name_chip.dart';
import 'distance_chip.dart';
import 'pinned_chip.dart';

class RideMetaChips extends StatelessWidget {
  final String customerName;
  final dynamic distance;

  const RideMetaChips({required this.customerName, this.distance, super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        CustomerNameChip(name: customerName),
        if (distance != null) DistanceChip(distance: distance),
        const PinnedChip(),
      ],
    );
  }
}
