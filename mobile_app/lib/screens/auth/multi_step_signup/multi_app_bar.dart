import 'package:flutter/material.dart';

class MultiAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MultiAppBar({super.key});

  @override
  Widget build(BuildContext context) => AppBar(title: const Text('Complete Profile'));

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
