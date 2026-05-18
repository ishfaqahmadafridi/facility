import 'package:flutter/material.dart';

class ChatCallButtons3 extends StatelessWidget {
  final VoidCallback? onChat;
  final VoidCallback? onCall;
  const ChatCallButtons3({this.onChat, this.onCall, super.key});

  @override
  Widget build(BuildContext context) => Row(children: [IconButton(icon: const Icon(Icons.chat_bubble), onPressed: onChat), IconButton(icon: const Icon(Icons.call), onPressed: onCall)]);
}
