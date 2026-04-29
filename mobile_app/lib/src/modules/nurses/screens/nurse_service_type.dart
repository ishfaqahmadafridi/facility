import 'package:flutter/material.dart';
import '../../../../config/routes.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../booking/widgets/service_category_card.dart';

class NurseServiceTypeScreen extends StatelessWidget {
  const NurseServiceTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medical Services')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('Select Nursing Service', style: AppTextStyles.h2),
          const SizedBox(height: 24),
          ServiceCategoryCard(
            title: 'IV Drip Administration',
            icon: Icons.vaccines,
            onTap: () => Navigator.pushNamed(context, AppRoutes.bookingForm, arguments: 'IV Drip'),
          ),
          const SizedBox(height: 16),
          ServiceCategoryCard(
            title: 'General Checkup',
            icon: Icons.monitor_heart,
            onTap: () => Navigator.pushNamed(context, AppRoutes.bookingForm, arguments: 'General Checkup'),
          ),
          const SizedBox(height: 16),
          ServiceCategoryCard(
            title: 'Post-Surgery Care',
            icon: Icons.healing,
            onTap: () => Navigator.pushNamed(context, AppRoutes.bookingForm, arguments: 'Post-Surgery Care'),
          ),
        ],
      ),
    );
  }
}
