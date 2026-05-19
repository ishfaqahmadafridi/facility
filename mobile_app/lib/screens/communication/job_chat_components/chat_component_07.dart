import 'package:flutter/material.dart';

class ChatComponent07 extends StatelessWidget {
  const ChatComponent07({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: const [
            Icon(Icons.location_on),
            SizedBox(width: 8),
            Expanded(child: Text('Chat comp 07')),
          ],
        ),
      ),
    );
  }
}
