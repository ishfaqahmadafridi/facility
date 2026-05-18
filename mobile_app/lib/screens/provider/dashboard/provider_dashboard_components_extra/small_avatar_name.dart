import 'package:flutter/material.dart';

class SmallAvatarName extends StatelessWidget {
  final String name;
  const SmallAvatarName({required this.name, super.key});

  @override
  Widget build(BuildContext context) => Row(children: [const CircleAvatar(radius: 12, child: Icon(Icons.person, size: 12)), const SizedBox(width: 8), Text(name)]);
}
