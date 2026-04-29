import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../providers/provider_panel_provider.dart';
import '../widgets/job_status_badge.dart';

class ProviderHomeScreen extends StatelessWidget {
  const ProviderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProviderPanelProvider>();

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        title: const Text('Partner Dashboard'),
        actions: [
          Row(
            children: [
              Text(provider.isOnline ? 'ONLINE' : 'OFFLINE', 
                style: TextStyle(color: provider.isOnline ? AppColors.success : AppColors.neutral400, fontWeight: FontWeight.bold)
              ),
              Switch(
                value: provider.isOnline,
                activeColor: AppColors.success,
                onChanged: (val) => provider.toggleOnlineStatus(),
              ),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daily Summary
            Row(
              children: [
                _buildSummaryCard('Today\'s Earnings', 'Rs. 4,500', Icons.account_balance_wallet),
                const SizedBox(width: 16),
                _buildSummaryCard('Jobs Done', '6', Icons.check_circle),
              ],
            ),
            const SizedBox(height: 32),
            const Text('Incoming Requests', style: AppTextStyles.h2),
            const SizedBox(height: 16),
            
            if (!provider.isOnline)
              const Expanded(
                child: Center(
                  child: Text('Go online to receive requests.', style: AppTextStyles.bodySecondary),
                ),
              )
            else if (provider.incomingJobs.isEmpty)
              const Expanded(
                child: Center(
                  child: Text('Looking for nearby jobs...', style: AppTextStyles.bodySecondary),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: provider.incomingJobs.length,
                  itemBuilder: (context, index) {
                    final job = provider.incomingJobs[index];
                    return _buildJobCard(context, job, provider);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(height: 16),
            Text(value, style: AppTextStyles.h2),
            Text(title, style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }

  Widget _buildJobCard(BuildContext context, Map<String, dynamic> job, ProviderPanelProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(job['type'] ?? 'Ride Request', style: AppTextStyles.h3),
              Text('Rs. ${job['price']}', style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(job['address'] ?? 'Unknown location', style: AppTextStyles.bodySecondary),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => provider.declineJob(job['id']),
                  child: const Text('Decline', style: TextStyle(color: AppColors.danger)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => provider.acceptJob(job['id']),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  child: const Text('Accept', style: TextStyle(color: AppColors.white)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
