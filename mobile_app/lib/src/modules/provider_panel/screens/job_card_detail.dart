import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../common_widgets/app_button.dart';

class JobCardDetailScreen extends StatelessWidget {
  const JobCardDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Job Details')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Customer: Ali Khan', style: AppTextStyles.h2),
            const SizedBox(height: 8),
            const Text('Rating: 4.8 ⭐', style: AppTextStyles.bodySecondary),
            const SizedBox(height: 24),
            
            _buildDetailRow('Service Type', 'Plumbing - Fix a Leak'),
            _buildDetailRow('Location', 'DHA Phase 6, Lahore'),
            _buildDetailRow('Estimated Price', 'Rs. 1,500'),
            _buildDetailRow('Notes', 'Please bring a spare wrench.'),
            
            const Spacer(),
            AppButton(
              label: 'Navigate to Customer',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.bodySmall),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.body),
        ],
      ),
    );
  }
}
