import 'package:flutter/material.dart';

class CheckoutAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CheckoutAppBar({required this.title, super.key});

  @override
  Widget build(BuildContext context) => AppBar(title: Text(title), backgroundColor: Colors.blue, foregroundColor: Colors.white);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
