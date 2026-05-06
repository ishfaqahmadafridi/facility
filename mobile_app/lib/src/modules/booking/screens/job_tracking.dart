import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../common_widgets/avatar_widget.dart';

class JobTrackingScreen extends StatelessWidget {
  const JobTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Job Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Status: En Route', style: AppTextStyles.h2),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.neutral700),
              ),
              child: const Row(
                children: [
                  AvatarWidget(radius: 24),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tariq Plumber', style: AppTextStyles.h3),
                        Text('4.9 Rating', style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                  Icon(Icons.phone, color: AppColors.success),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
