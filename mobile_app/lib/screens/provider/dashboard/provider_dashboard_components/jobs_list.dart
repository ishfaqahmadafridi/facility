import 'package:flutter/material.dart';
import 'job_card.dart';

class JobsList extends StatelessWidget {
  final List<dynamic> jobs;
  final void Function(Map<String, dynamic>) onAccept;

  const JobsList({required this.jobs, required this.onAccept, super.key});

  @override
  Widget build(BuildContext context) {
    if (jobs.isEmpty) return const Padding(padding: EdgeInsets.all(16), child: Text('No available jobs nearby matching your categories.', style: TextStyle(color: Colors.grey)));

    return Column(children: jobs.map((jobData) {
      final job = (jobData as Map).cast<String, dynamic>();
      return JobCard(job: job, onAccept: onAccept);
    }).toList());
  }
}
