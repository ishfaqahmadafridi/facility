import 'package:flutter/material.dart';

class ProviderMeta extends StatelessWidget {
  final double rating;
  final String distance;
  const ProviderMeta({required this.rating, required this.distance, super.key});

  @override
  Widget build(BuildContext context) => Row(children: [const Icon(Icons.star, color: Colors.orange, size: 16), Text(' $rating', style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(width: 12), const Icon(Icons.location_on, color: Colors.grey, size: 16), Text(' $distance km away')]);
}
