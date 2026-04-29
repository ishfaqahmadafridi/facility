import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../../config/routes.dart';

class RideActiveScreen extends StatelessWidget {
  const RideActiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: AppColors.neutral800,
            child: const Center(
              child: Text('Live Navigation Map Here', style: TextStyle(color: AppColors.neutral400)),
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
                  const Text('Driver is on the way', style: AppTextStyles.h2),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      const CircleAvatar(radius: 24, backgroundColor: AppColors.neutral700),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Ahmed Ali', style: AppTextStyles.h3),
                            Text('Honda Civic - LEB 1234', style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutral400)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chat, color: AppColors.primary),
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.negotiationChat),
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
