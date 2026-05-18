import 'package:flutter/material.dart';

class SortButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const SortButton({this.onPressed, super.key});

  @override
  Widget build(BuildContext context) => IconButton(icon: const Icon(Icons.sort), onPressed: onPressed);
}
