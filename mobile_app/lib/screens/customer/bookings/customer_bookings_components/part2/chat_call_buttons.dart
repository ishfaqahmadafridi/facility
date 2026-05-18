import 'package:flutter/material.dart';

class ChatCallButtons2 extends StatelessWidget {
  final VoidCallback? onChat;
  final VoidCallback? onCall;
  const ChatCallButtons2({this.onChat, this.onCall, super.key});

  @override
  Widget build(BuildContext context) => Row(children: [IconButton(icon: const Icon(Icons.chat), onPressed: onChat), IconButton(icon: const Icon(Icons.call), onPressed: onCall)]);
}
