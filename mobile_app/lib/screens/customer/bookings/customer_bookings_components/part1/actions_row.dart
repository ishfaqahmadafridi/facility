import 'package:flutter/material.dart';

class ActionsRow1 extends StatelessWidget {
  final VoidCallback? onChat;
  final VoidCallback? onCall;
  const ActionsRow1({this.onChat, this.onCall, super.key});

  @override
  Widget build(BuildContext context) => Row(children: [Expanded(child: OutlinedButton.icon(onPressed: onChat, icon: const Icon(Icons.chat_bubble_outline), label: const Text('Chat'))), const SizedBox(width: 12), Expanded(child: ElevatedButton.icon(onPressed: onCall, icon: const Icon(Icons.call), label: const Text('Call')))]);
}
