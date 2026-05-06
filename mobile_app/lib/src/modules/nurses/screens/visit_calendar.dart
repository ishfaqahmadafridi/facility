import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';

class VisitCalendarScreen extends StatelessWidget {
  const VisitCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Care Schedule')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Upcoming Visits', style: AppTextStyles.h2),
            const SizedBox(height: 24),
            _buildVisitTile(date: 'Oct 28', day: 'Monday', time: '10:00 AM', status: 'CONFIRMED'),
            const SizedBox(height: 16),
            _buildVisitTile(date: 'Oct 31', day: 'Thursday', time: '10:00 AM', status: 'SCHEDULED'),
            const SizedBox(height: 16),
            _buildVisitTile(date: 'Nov 04', day: 'Monday', time: '10:00 AM', status: 'SCHEDULED'),
          ],
        ),
      ),
    );
  }

  Widget _buildVisitTile({required String date, required String day, required String time, required String status}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neutral700),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(date.split(' ')[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                Text(date.split(' ')[1], style: const TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(day, style: AppTextStyles.h3),
                const SizedBox(height: 4),
                Text(time, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: status == 'CONFIRMED' ? AppColors.success.withOpacity(0.1) : AppColors.neutral700,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: status == 'CONFIRMED' ? AppColors.success : AppColors.neutral400,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
