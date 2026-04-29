import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';

class NavigateToJobScreen extends StatelessWidget {
  const NavigateToJobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: AppColors.neutral800,
            child: const Center(
              child: Text('Map View - Navigating to Customer', style: TextStyle(color: AppColors.neutral400)),
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
                  const Text('ETA: 12 mins (4.5 km)', style: AppTextStyles.h2),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('I Have Arrived', style: TextStyle(color: AppColors.white)),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
