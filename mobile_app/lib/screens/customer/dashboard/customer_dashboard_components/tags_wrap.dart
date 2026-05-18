import 'package:flutter/material.dart';

class TagsWrap extends StatelessWidget {
  final List<dynamic> tags;
  const TagsWrap({required this.tags, super.key});

  @override
  Widget build(BuildContext context) => Wrap(spacing: 4, children: tags.map((t) => Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(4)), child: Text(t.toString(), style: const TextStyle(fontSize: 10, color: Colors.blue)))).toList());
}
