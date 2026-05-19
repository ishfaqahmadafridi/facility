import 'package:flutter/material.dart';

class ChatComponent20 extends StatelessWidget {
  const ChatComponent20({super.key});

  @override
  Widget build(BuildContext context) => Card(margin: const EdgeInsets.only(bottom:8), child: Padding(padding: const EdgeInsets.all(12), child: Row(children: const [Icon(Icons.error_outline), SizedBox(width:8), Expanded(child: Text('Chat comp 20'))],),));
}
