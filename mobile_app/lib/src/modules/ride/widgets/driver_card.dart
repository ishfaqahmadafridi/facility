import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../common_widgets/avatar_widget.dart';
import '../../../common_widgets/app_button.dart';

class DriverCard extends StatelessWidget {
  final String driverId;
  final double bidAmount;
  final double rating;
  final VoidCallback onAccept;

  const DriverCard({
    super.key,
    required this.driverId,
    required this.bidAmount,
    required this.rating,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neutral700),
      ),
      child: Row(
        children: [
          const AvatarWidget(radius: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Driver ${driverId.substring(0, 8)}', style: AppTextStyles.h3),
                Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.warning, size: 16),
                    const SizedBox(width: 4),
                    Text(rating.toString(), style: AppTextStyles.bodySmall),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Rs. $bidAmount', style: AppTextStyles.h2.copyWith(color: AppColors.primary)),
              const SizedBox(height: 8),
              SizedBox(
                height: 36,
                child: ElevatedButton(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
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
