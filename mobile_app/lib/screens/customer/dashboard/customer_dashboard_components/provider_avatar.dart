import 'package:flutter/material.dart';

class ProviderAvatar extends StatelessWidget {
  final String? imageUrl;
  const ProviderAvatar({this.imageUrl, super.key});

  @override
  Widget build(BuildContext context) => CircleAvatar(radius: 30, backgroundColor: Colors.blue.shade100, child: const Icon(Icons.person, size: 30, color: Colors.blue));
}
