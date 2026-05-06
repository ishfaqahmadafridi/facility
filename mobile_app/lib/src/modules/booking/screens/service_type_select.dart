import 'package:flutter/material.dart';
import '../../../../config/routes.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../widgets/service_category_card.dart';

class ServiceTypeSelectScreen extends StatelessWidget {
  const ServiceTypeSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String category = ModalRoute.of(context)?.settings.arguments as String? ?? 'Service';

    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('What do you need help with?', style: AppTextStyles.h2),
          const SizedBox(height: 24),
          ServiceCategoryCard(
            title: 'Fix a Leak',
            icon: Icons.water_drop,
            onTap: () => Navigator.pushNamed(context, AppRoutes.bookingForm, arguments: 'Fix a Leak'),
          ),
          const SizedBox(height: 16),
          ServiceCategoryCard(
            title: 'Pipe Installation',
            icon: Icons.architecture,
            onTap: () => Navigator.pushNamed(context, AppRoutes.bookingForm, arguments: 'Pipe Installation'),
          ),
        ],
      ),
    );
  }
}
