import 'package:flutter/material.dart';

class RatingRow extends StatelessWidget {
  final double rating;
  final String experience;
  const RatingRow({required this.rating, required this.experience, super.key});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.star, color: Colors.orange),
          Text(' $rating', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(width: 16),
          const Icon(Icons.work, color: Colors.grey),
          Text(' Exp: $experience', style: const TextStyle(fontSize: 16)),
        ],
      );
}
