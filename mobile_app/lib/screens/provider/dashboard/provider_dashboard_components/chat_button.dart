import 'package:flutter/material.dart';

class ChatButton extends StatelessWidget {
  final VoidCallback onPressed;
  const ChatButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) => IconButton(icon: const Icon(Icons.chat_bubble_outline), onPressed: onPressed);
}
