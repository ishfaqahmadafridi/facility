import 'package:flutter/material.dart';

class ChatComponent05 extends StatelessWidget {
  const ChatComponent05({super.key});

  @override
  Widget build(BuildContext context) => Card(margin: const EdgeInsets.only(bottom:8), child: Padding(padding: const EdgeInsets.all(12), child: Row(children: const [Icon(Icons.play_arrow), SizedBox(width:8), Expanded(child: Text('Chat comp 05'))],),));
}
