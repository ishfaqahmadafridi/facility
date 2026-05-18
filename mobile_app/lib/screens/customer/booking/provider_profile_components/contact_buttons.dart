import 'package:flutter/material.dart';

class ContactButtons extends StatelessWidget {
  final VoidCallback? onCall;
  final VoidCallback? onMessage;
  const ContactButtons({this.onCall, this.onMessage, super.key});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(icon: const Icon(Icons.call), onPressed: onCall),
          const SizedBox(width: 8),
          IconButton(icon: const Icon(Icons.message), onPressed: onMessage),
        ],
      );
}
