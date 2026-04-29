// lib/src/modules/onboarding/screens/permissions_screen.dart
import 'package:flutter/material.dart';
import '../../../../config/routes.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../common_widgets/app_button.dart';

class PermissionsScreen extends StatelessWidget {
  const PermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              const Icon(Icons.location_on, size: 80, color: AppColors.primary),
              const SizedBox(height: 32),
              const Text(
                'Enable Location',
                style: AppTextStyles.display2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'We need your location to find nearby drivers, nurses, and mechanics.',
                style: AppTextStyles.body,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              AppButton(
                label: 'Allow Access',
                onPressed: () {
                  // In real app, request Geolocator permissions here
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                },
                child: const Text('Not Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
