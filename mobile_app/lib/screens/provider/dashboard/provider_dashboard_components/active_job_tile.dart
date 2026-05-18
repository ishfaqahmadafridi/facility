import 'package:flutter/material.dart';

class ActiveJobTile extends StatelessWidget {
  final Map<String, dynamic> job;
  final void Function(Map<String, dynamic>) onChat;
  final void Function(Map<String, dynamic>) onCall;

  const ActiveJobTile({required this.job, required this.onChat, required this.onCall, super.key});

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: ListTile(
          title: Text(job['title']?.toString() ?? 'Assigned Job'),
          subtitle: Text(job['status']?.toString() ?? 'ACCEPTED'),
          trailing: Wrap(spacing: 8, children: [IconButton(icon: const Icon(Icons.chat_bubble_outline), onPressed: () => onChat(job)), IconButton(icon: const Icon(Icons.call_outlined), onPressed: () => onCall(job))]),
        ),
      );
}
