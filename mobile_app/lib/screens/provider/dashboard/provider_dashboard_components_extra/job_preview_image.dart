import 'package:flutter/material.dart';

class JobPreviewImage extends StatelessWidget {
  final String? url;
  const JobPreviewImage({this.url, super.key});

  @override
  Widget build(BuildContext context) => Container(width: 64, height: 64, color: Colors.grey.shade200, child: const Icon(Icons.image));
}
