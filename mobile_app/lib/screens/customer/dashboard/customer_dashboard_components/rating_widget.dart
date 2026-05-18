import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  const RatingWidget({required this.rating, super.key});

  @override
  Widget build(BuildContext context) => Row(children: [const Icon(Icons.star, color: Colors.orange, size: 16), Text(' $rating', style: const TextStyle(fontWeight: FontWeight.bold))]);
}
