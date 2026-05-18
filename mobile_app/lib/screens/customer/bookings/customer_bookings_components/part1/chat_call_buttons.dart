import 'package:flutter/material.dart';

class ChatCallButtons1 extends StatelessWidget {
  final VoidCallback? onChat;
  final VoidCallback? onCall;
  const ChatCallButtons1({this.onChat, this.onCall, super.key});

  @override
  Widget build(BuildContext context) => Row(children: [IconButton(icon: const Icon(Icons.chat_bubble_outline), onPressed: onChat), IconButton(icon: const Icon(Icons.call), onPressed: onCall)]);
}
