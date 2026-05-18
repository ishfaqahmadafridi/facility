import 'package:flutter/material.dart';
import '../components/ride_meta_chips.dart' as base;

class RideMetaChips extends StatelessWidget {
  final String customerName;
  final dynamic distance;

  const RideMetaChips({required this.customerName, this.distance, super.key});

  @override
  Widget build(BuildContext context) => base.RideMetaChips(customerName: customerName, distance: distance);
}
