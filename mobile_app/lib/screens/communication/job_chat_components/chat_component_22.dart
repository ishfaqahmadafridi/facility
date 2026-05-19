import 'package:flutter/material.dart';

class ChatComponent22 extends StatelessWidget {
  const ChatComponent22({super.key});

  @override
  Widget build(BuildContext context) => Card(margin: const EdgeInsets.only(bottom:8), child: Padding(padding: const EdgeInsets.all(12), child: Row(children: const [Icon(Icons.verified), SizedBox(width:8), Expanded(child: Text('Chat comp 22'))],),));
}
