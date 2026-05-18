import 'package:flutter/material.dart';

class RideActionsRow extends StatelessWidget {
  final String rideId;
  final num fare;
  final void Function(String, num) onCounter;
  final void Function(String) onAccept;

  const RideActionsRow({required this.rideId, required this.fare, required this.onCounter, required this.onAccept, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => onCounter(rideId, fare),
            child: const Text('Counter Offer'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () => onAccept(rideId),
            child: const Text('Accept'),
          ),
        ),
      ],
    );
  }
}
