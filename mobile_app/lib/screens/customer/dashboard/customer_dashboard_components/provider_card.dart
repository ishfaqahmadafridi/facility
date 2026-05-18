import 'package:flutter/material.dart';

class ProviderCard extends StatelessWidget {
  final dynamic provider;
  final VoidCallback? onTap;
  const ProviderCard({required this.provider, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final user = provider['user'] ?? {};
    final fullName = user['full_name'] ?? user['phone_number'] ?? 'Provider';
    final distance = provider['distance_km'] ?? 'Unknown';
    final rating = provider['rating'] ?? 0.0;
    final categories = (provider['categories'] as List<dynamic>?) ?? [];

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: const CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.person, size: 30, color: Colors.white),
        ),
        title: Text(fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 16),
                Text(' $rating', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 12),
                const Icon(Icons.location_on, color: Colors.grey, size: 16),
                Text(' $distance km away'),
              ],
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 4,
              children: categories.map<Widget>((cat) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(4)),
                  child: Text(cat.toString(), style: const TextStyle(fontSize: 10, color: Colors.blue)),
                );
              }).toList(),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
