import 'package:flutter/material.dart';

class ChatComponent06 extends StatelessWidget {
  const ChatComponent06({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.volume_up),
            SizedBox(width: 8),
            Expanded(child: Text('Chat comp 06')),
          ],
        ),
      ),
    );
  }
}
