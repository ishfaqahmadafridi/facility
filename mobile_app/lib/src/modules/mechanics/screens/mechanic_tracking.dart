import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';

class MechanicTrackingScreen extends StatelessWidget {
  const MechanicTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: AppColors.neutral800,
            child: const Center(
              child: Text('Live Map\nMechanic En Route', textAlign: TextAlign.center, style: TextStyle(color: AppColors.neutral400)),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Help is on the way!', style: AppTextStyles.h2),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const CircleAvatar(radius: 24, backgroundColor: AppColors.neutral700),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hassan (Mobile Mechanic)', style: AppTextStyles.h3),
                            Text('ETA: 12 mins', style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.phone, color: AppColors.success),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
