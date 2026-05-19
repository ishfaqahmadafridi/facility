import 'package:flutter/material.dart';

/// The AppBar for the Job Chat view.
class JobChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const JobChatAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
