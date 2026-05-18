import 'package:flutter/material.dart';
import 'active_job_tile.dart';

class ActiveJobsList extends StatelessWidget {
  final List<dynamic> jobs;
  final void Function(Map<String, dynamic>) onChat;
  final void Function(Map<String, dynamic>) onCall;

  const ActiveJobsList({required this.jobs, required this.onChat, required this.onCall, super.key});

  @override
  Widget build(BuildContext context) {
    if (jobs.isEmpty) return const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('No active job chats yet.', style: TextStyle(color: Colors.grey)));

    return Column(children: jobs.map((jobData) {
      final job = (jobData as Map).cast<String, dynamic>();
      return ActiveJobTile(job: job, onChat: onChat, onCall: onCall);
    }).toList());
  }
}
