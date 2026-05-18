import 'package:flutter/material.dart';

class JobCard extends StatelessWidget {
  final Map<String, dynamic> job;
  final void Function(Map<String, dynamic>) onAccept;

  const JobCard({required this.job, required this.onAccept, super.key});

  @override
  Widget build(BuildContext context) {
    final title = job['title'] ?? 'Job Request';
    final distance = job['distance_km'] ?? '?';
    final price = job['price'] ?? 'Negotiable';
    final customer = job['customer']?['user'] ?? {};
    final customerName = customer['full_name'] ?? customer['phone_number'] ?? 'Customer';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Text(title.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))), Text('Rs $price', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16))]),
          const SizedBox(height: 8),
          Text(customerName.toString(), style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 6),
          Row(children: [const Icon(Icons.location_on, size: 16, color: Colors.grey), const SizedBox(width: 4), Text('$distance km away', style: const TextStyle(color: Colors.grey))]),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white), onPressed: () => onAccept(job), child: const Text('Accept Job')))
        ]),
      ),
    );
  }
}
