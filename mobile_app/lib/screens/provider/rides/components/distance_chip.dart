import 'package:flutter/material.dart';
import 'ride_meta_chip.dart';

class DistanceChip extends StatelessWidget {
  final dynamic distance;
  const DistanceChip({this.distance, super.key});

  @override
  Widget build(BuildContext context) => RideMetaChip(icon: Icons.near_me, label: '${distance ?? '?'} km away');
}
