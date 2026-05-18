import 'package:flutter/material.dart';
import '../components/ride_card.dart' as base;

class RideCard extends StatelessWidget {
  final Map<String, dynamic> ride;
  final void Function(String, num) onCounter;
  final void Function(String) onAccept;

  const RideCard({required this.ride, required this.onCounter, required this.onAccept, super.key});

  @override
  Widget build(BuildContext context) => base.RideCard(ride: ride, onCounter: onCounter, onAccept: onAccept);
}
