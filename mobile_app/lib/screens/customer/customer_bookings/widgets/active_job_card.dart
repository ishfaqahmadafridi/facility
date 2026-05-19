import 'package:flutter/material.dart';
import '../../../../shared/widgets/info_chip.dart';

/// Reusable card displaying an active job for the customer.
class ActiveJobCard extends StatelessWidget {
  final Map<String, dynamic> job;
  final VoidCallback onChat;
  final VoidCallback onCall;

  const ActiveJobCard({
    super.key,
    required this.job,
    required this.onChat,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    final provider = job['provider'] ?? {};
    final providerUser = provider['user'] ?? {};
    final providerName = providerUser['full_name'] ?? providerUser['phone_number'] ?? 'Assigned provider';
    final status = job['status'] ?? 'PENDING';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job['title']?.toString() ?? 'Service Request', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(job['description']?.toString() ?? 'No description'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                InfoChip(icon: Icons.person_outline, label: providerName),
                InfoChip(icon: Icons.info_outline, label: status),
                if (job['price'] != null) InfoChip(icon: Icons.payments_outlined, label: 'Rs ${job['price']}'),
              ],
            ),
            if (provider['id'] != null) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onChat,
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: const Text('Chat'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onCall,
                      icon: const Icon(Icons.call),
                      label: const Text('Call'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
