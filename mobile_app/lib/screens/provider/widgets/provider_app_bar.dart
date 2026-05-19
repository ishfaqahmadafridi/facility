import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/mode_badge.dart';

/// Provider-mode AppBar with brand name + radius subtitle.
class ProviderAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProviderAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppConstants.appName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          Text(
            '📍 Expected Job Radius: ${AppConstants.providerDefaultRadius.toInt()}km',
            style: const TextStyle(fontSize: 12, color: AppColors.textOnPrimaryFaded),
          ),
        ],
      ),
      backgroundColor: AppColors.providerPrimary,
      foregroundColor: AppColors.textOnPrimary,
      actions: const [ModeBadge(isProvider: true)],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
