import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../../config/routes.dart';
import '../providers/booking_provider.dart';

class ProviderSearchingScreen extends StatelessWidget {
  const ProviderSearchingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();
    final booking = provider.currentBooking;

    // In a real app, when the provider's status changes to ACCEPTED, we auto-navigate.
    if (booking?.status == 'ACCEPTED') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, AppRoutes.jobTracking);
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: 24),
            const Text('Finding a Professional...', style: AppTextStyles.h2),
            const SizedBox(height: 8),
            const Text('We are contacting nearby providers.', style: AppTextStyles.bodySecondary),
            
            const SizedBox(height: 48),
            // Mock trigger for demo purposes
            TextButton(
              onPressed: () {
                // Simulate backend accepting the booking
                Navigator.pushReplacementNamed(context, AppRoutes.jobTracking);
              },
              child: const Text('Simulate Provider Accept'),
            )
          ],
        ),
      ),
    );
  }
}
