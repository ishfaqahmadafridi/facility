import 'package:flutter/material.dart';
import 'review_item.dart';

class ReviewsSection extends StatelessWidget {
  final List<Map<String, String>> reviews;
  const ReviewsSection({required this.reviews, super.key});

  @override
  Widget build(BuildContext context) => Column(
        children: reviews.map((r) => ReviewItem(author: r['author']!, text: r['text']!)).toList(),
      );
}
