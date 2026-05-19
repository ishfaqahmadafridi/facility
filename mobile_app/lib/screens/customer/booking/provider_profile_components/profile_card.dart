import 'package:flutter/material.dart';
import 'avatar.dart';
import 'name_title.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  const ProfileCard({required this.name, super.key});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const ProviderAvatar(),
          const SizedBox(height: 16),
          NameTitle(name: name),
        ],
      );
}
