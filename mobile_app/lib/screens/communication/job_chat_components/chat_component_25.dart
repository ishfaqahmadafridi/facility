import 'package:flutter/material.dart';

class ChatComponent25 extends StatelessWidget {
  const ChatComponent25({super.key});

  @override
  Widget build(BuildContext context) => Card(margin: const EdgeInsets.only(bottom:8), child: Padding(padding: const EdgeInsets.all(12), child: Row(children: const [Icon(Icons.check), SizedBox(width:8), Expanded(child: Text('Chat comp 25'))],),));
}
