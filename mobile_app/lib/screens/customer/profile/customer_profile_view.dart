import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/dual_mode_provider.dart';
import 'components/profile_placeholder.dart';

class CustomerProfileView extends StatelessWidget {
  const CustomerProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
        const SizedBox(height: 16),
        const Center(child: Text('My Profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
        const SizedBox(height: 30),
        
        ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          tileColor: Colors.grey.shade100,
          leading: const Icon(Icons.swap_horiz, color: Colors.blue),
          title: const Text('Switch to Provider Mode', style: TextStyle(fontWeight: FontWeight.bold)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () async {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Switching Mode...')),
            );
            final provider = Provider.of<DualModeProvider>(context, listen: false);
            final success = await provider.toggleMode();
            if (context.mounted) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              if (!success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to switch mode. Complete Provider Profile first!')),
                );
              }
            }
          },
        ),
        
        const SizedBox(height: 15),
        const ProfilePlaceholder(),
      ],
    );
  }
}

