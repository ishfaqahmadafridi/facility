import 'package:flutter/material.dart';

class AvatarSmall extends StatelessWidget {
  const AvatarSmall({super.key});

  @override
  Widget build(BuildContext context) => const CircleAvatar(radius: 16, child: Icon(Icons.person, size: 16));
}
