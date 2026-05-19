import 'package:flutter/material.dart';

class ReviewItem extends StatelessWidget {
  final String author;
  final String text;
  const ReviewItem({required this.author, required this.text, super.key});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(author),
            subtitle: Text(text),
            trailing: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [Icon(Icons.star, color: Colors.orange, size: 16), Text('5.0')],
            ),
          ),
          const Divider(),
        ],
      );
}
