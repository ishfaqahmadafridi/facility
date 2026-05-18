import 'package:flutter/material.dart';
import '../components/ride_actions_row.dart' as base;

class RideActionsRow extends StatelessWidget {
  final String rideId;
  final num fare;
  final void Function(String, num) onCounter;
  final void Function(String) onAccept;

  const RideActionsRow({required this.rideId, required this.fare, required this.onCounter, required this.onAccept, super.key});

  @override
  Widget build(BuildContext context) => base.RideActionsRow(rideId: rideId, fare: fare, onCounter: onCounter, onAccept: onAccept);
}
