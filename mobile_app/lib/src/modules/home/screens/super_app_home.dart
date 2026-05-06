import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/routes.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../auth/providers/auth_provider.dart';

class SuperAppHome extends StatelessWidget {
  const SuperAppHome({super.key});

  Widget _verticalButton(BuildContext context, String title, IconData icon, Color color, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.neutral700, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36, color: color),
            ),
            const SizedBox(height: 12),
            Text(title, style: AppTextStyles.h3),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SUPERAPP', style: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold)),
        actions: [
          // Wallet shortcut in top bar
          IconButton(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.walletDashboard),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              final auth = Provider.of<AuthProvider>(context, listen: false);
              if (auth.isAuthenticated) {
                Navigator.pushNamed(context, AppRoutes.profile);
              } else {
                Navigator.pushNamed(context, AppRoutes.phoneEntry);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('What do you need?', style: AppTextStyles.display2),
              const SizedBox(height: 8),
              const Text('Select a service to continue', style: AppTextStyles.bodySecondary),
              const SizedBox(height: 32),
              
              // 5-vertical grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _verticalButton(context, 'Ride', Icons.directions_car, AppColors.info, AppRoutes.rideMap),
                    _verticalButton(context, 'Medical', Icons.medical_services, AppColors.success, AppRoutes.nurseServiceType),
                    _verticalButton(context, 'Roadside', Icons.car_crash, AppColors.danger, AppRoutes.emergencyHome),
                    _verticalButton(context, 'Repairs', Icons.home_repair_service, AppColors.primary, AppRoutes.serviceCategories),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              // Provider mode entry CTA
              GestureDetector(
                onTap: () {
                  final auth = Provider.of<AuthProvider>(context, listen: false);
                  if (auth.isAuthenticated) {
                    Navigator.pushNamed(context, AppRoutes.providerHome);
                  } else {
                    Navigator.pushNamed(context, AppRoutes.phoneEntry);
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.work_outline, color: AppColors.primary),
                      SizedBox(width: 12),
                      Text('Switch to Partner Mode', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
