import 'package:flutter/material.dart';

class ChatComponent23 extends StatelessWidget {
  const ChatComponent23({super.key});

  @override
  Widget build(BuildContext context) => const Card(margin: EdgeInsets.only(bottom:8), child: Padding(padding: EdgeInsets.all(12), child: Row(children: [Icon(Icons.settings), SizedBox(width:8), Expanded(child: Text('Chat comp 23'))],),));
}
