import 'package:flutter/material.dart';

class ChatComponent01 extends StatelessWidget {
  const ChatComponent01({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(margin: EdgeInsets.only(bottom: 8), child: Padding(padding: EdgeInsets.all(12), child: Row(children: [Icon(Icons.chat), SizedBox(width:8), Expanded(child: Text('Chat comp 01'))],),));
  }
}
