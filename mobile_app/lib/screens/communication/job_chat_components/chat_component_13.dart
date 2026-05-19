import 'package:flutter/material.dart';

class ChatComponent13 extends StatelessWidget {
  const ChatComponent13({super.key});

  @override
  Widget build(BuildContext context) => const Card(margin: EdgeInsets.only(bottom:8), child: Padding(padding: EdgeInsets.all(12), child: Row(children: [Icon(Icons.calendar_today), SizedBox(width:8), Expanded(child: Text('Chat comp 13'))],),));
}
