import 'package:flutter/material.dart';

class ChatComponent07 extends StatelessWidget {
  const ChatComponent07({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.location_on),
            SizedBox(width: 8),
            Expanded(child: Text('Chat comp 07')),
          ],
        ),
      ),
    );
  }
}
