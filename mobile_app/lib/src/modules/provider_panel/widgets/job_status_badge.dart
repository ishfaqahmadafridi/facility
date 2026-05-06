import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';

class JobStatusBadge extends StatelessWidget {
  final String status;

  const JobStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (status.toUpperCase()) {
      case 'PENDING':
      case 'SEARCHING':
        bgColor = AppColors.warning.withOpacity(0.2);
        textColor = AppColors.warning;
        break;
      case 'ACCEPTED':
      case 'EN_ROUTE':
        bgColor = AppColors.primary.withOpacity(0.2);
        textColor = AppColors.primary;
        break;
      case 'COMPLETED':
        bgColor = AppColors.success.withOpacity(0.2);
        textColor = AppColors.success;
        break;
      default:
        bgColor = AppColors.neutral700;
        textColor = AppColors.neutral400;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
