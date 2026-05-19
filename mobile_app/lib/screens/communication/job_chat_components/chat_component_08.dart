import 'package:flutter/material.dart';

class ChatComponent08 extends StatelessWidget {
  const ChatComponent08({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.thumb_up),
            SizedBox(width: 8),
            Expanded(child: Text('Chat comp 08')),
          ],
        ),
      ),
    );
  }
}
