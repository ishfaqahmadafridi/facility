import 'package:flutter/material.dart';

class ChatComponent12 extends StatelessWidget {
  const ChatComponent12({super.key});

  @override
  Widget build(BuildContext context) => const Card(margin: EdgeInsets.only(bottom:8), child: Padding(padding: EdgeInsets.all(12), child: Row(children: [Icon(Icons.warning), SizedBox(width:8), Expanded(child: Text('Chat comp 12'))],),));
}
