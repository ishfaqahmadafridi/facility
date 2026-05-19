import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';

/// Mode badge showing CUSTOMER or PROVIDER — extracted from both app bars.
class ModeBadge extends StatelessWidget {
  final bool isProvider;

  const ModeBadge({super.key, this.isProvider = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          isProvider ? 'PROVIDER' : 'CUSTOMER',
          style: AppTextStyles.badgeLabel,
        ),
      ),
    );
  }
}
