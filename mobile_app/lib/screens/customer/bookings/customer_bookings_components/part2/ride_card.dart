import 'package:flutter/material.dart';

class RideCard2 extends StatelessWidget {
  final Map<String, dynamic> ride;
  const RideCard2({required this.ride, super.key});

  @override
  Widget build(BuildContext context) => Card(margin: const EdgeInsets.only(bottom: 12), child: ListTile(title: Text('Ride to ${ride['dropoff_address'] ?? 'destination'}'), subtitle: Text('Pickup: ${ride['pickup_address'] ?? 'Unknown'}')));
}
