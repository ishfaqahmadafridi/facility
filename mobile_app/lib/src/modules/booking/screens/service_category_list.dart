import 'package:flutter/material.dart';
import '../../../../config/routes.dart';
import '../widgets/service_category_card.dart';

class ServiceCategoryListScreen extends StatelessWidget {
  const ServiceCategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Repairs')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          ServiceCategoryCard(
            title: 'Plumbing',
            icon: Icons.plumbing,
            onTap: () => Navigator.pushNamed(context, AppRoutes.serviceTypeSelect, arguments: 'PLUMBING'),
          ),
          const SizedBox(height: 16),
          ServiceCategoryCard(
            title: 'Electrician',
            icon: Icons.electrical_services,
            onTap: () => Navigator.pushNamed(context, AppRoutes.serviceTypeSelect, arguments: 'ELECTRICIAN'),
          ),
          const SizedBox(height: 16),
          ServiceCategoryCard(
            title: 'AC Maintenance',
            icon: Icons.ac_unit,
            onTap: () => Navigator.pushNamed(context, AppRoutes.serviceTypeSelect, arguments: 'AC_REPAIR'),
          ),
        ],
      ),
    );
  }
}
