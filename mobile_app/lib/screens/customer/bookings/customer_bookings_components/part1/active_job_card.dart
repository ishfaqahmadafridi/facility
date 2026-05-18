import 'package:flutter/material.dart';

class ActiveJobCard extends StatelessWidget {
  final Map<String, dynamic> job;
  final VoidCallback? onTap;
  const ActiveJobCard({required this.job, this.onTap, super.key});

  @override
  Widget build(BuildContext context) => Card(margin: const EdgeInsets.only(bottom: 12), child: ListTile(title: Text(job['title']?.toString() ?? 'Service Request'), subtitle: Text(job['description']?.toString() ?? 'No description'), onTap: onTap));
}
