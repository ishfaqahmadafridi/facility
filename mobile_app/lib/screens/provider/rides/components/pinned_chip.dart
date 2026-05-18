import 'package:flutter/material.dart';
import 'ride_meta_chip.dart';

class PinnedChip extends StatelessWidget {
  const PinnedChip({super.key});

  @override
  Widget build(BuildContext context) => const RideMetaChip(icon: Icons.pin_drop_outlined, label: 'Pinned route');
}
