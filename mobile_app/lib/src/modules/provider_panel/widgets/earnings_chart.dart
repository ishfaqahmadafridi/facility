import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';

class EarningsChart extends StatelessWidget {
  final List<double> weeklyEarnings;

  const EarningsChart({super.key, required this.weeklyEarnings});

  @override
  Widget build(BuildContext context) {
    // Simple mock bar chart
    final maxEarning = weeklyEarnings.reduce((a, b) => a > b ? a : b);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: weeklyEarnings.asMap().entries.map((entry) {
        final height = maxEarning == 0 ? 0.0 : (entry.value / maxEarning) * 150;
        final day = ['M', 'T', 'W', 'T', 'F', 'S', 'S'][entry.key];
        
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 24,
              height: height,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Text(day, style: const TextStyle(color: AppColors.neutral400, fontSize: 12)),
          ],
        );
      }).toList(),
    );
  }
}
