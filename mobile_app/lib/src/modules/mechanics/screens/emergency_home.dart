import 'package:flutter/material.dart';
import '../../../../config/routes.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';

class EmergencyHomeScreen extends StatelessWidget {
  const EmergencyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(title: const Text('Roadside Assistance')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Are you in a safe location?', style: AppTextStyles.h2),
            const SizedBox(height: 8),
            const Text('Please move your vehicle to the side of the road if possible.', 
                style: AppTextStyles.bodySecondary),
            const SizedBox(height: 32),
            
            _buildEmergencyCard(
              context,
              title: 'Request a Mechanic',
              subtitle: 'Flat tire, dead battery, or engine issues',
              icon: Icons.build,
              onTap: () => Navigator.pushNamed(context, AppRoutes.issueTypeSelect),
            ),
            const SizedBox(height: 16),
            _buildEmergencyCard(
              context,
              title: 'Request a Tow Truck',
              subtitle: 'Vehicle cannot be driven safely',
              icon: Icons.local_shipping,
              onTap: () => Navigator.pushNamed(context, AppRoutes.issueTypeSelect),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.danger.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.danger, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.h3),
                  Text(subtitle, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
