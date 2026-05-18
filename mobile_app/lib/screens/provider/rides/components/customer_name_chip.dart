import 'package:flutter/material.dart';
import 'ride_meta_chip.dart';

class CustomerNameChip extends StatelessWidget {
  final String name;
  const CustomerNameChip({required this.name, super.key});

  @override
  Widget build(BuildContext context) => RideMetaChip(icon: Icons.person_outline, label: name);
}
