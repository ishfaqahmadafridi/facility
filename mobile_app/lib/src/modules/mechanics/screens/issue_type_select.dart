import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../../config/routes.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/roadside_provider.dart';
import '../../booking/widgets/service_category_card.dart';

class IssueTypeSelectScreen extends StatelessWidget {
  const IssueTypeSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Issue')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('What seems to be the problem?', style: AppTextStyles.h2),
          const SizedBox(height: 24),
          ServiceCategoryCard(
            title: 'Flat Tire',
            icon: Icons.tire_repair,
            onTap: () => _requestAssistance(context, 'FLAT_TIRE'),
          ),
          const SizedBox(height: 16),
          ServiceCategoryCard(
            title: 'Dead Battery (Jump Start)',
            icon: Icons.battery_charging_full,
            onTap: () => _requestAssistance(context, 'BATTERY_JUMP'),
          ),
          const SizedBox(height: 16),
          ServiceCategoryCard(
            title: 'Empty Fuel',
            icon: Icons.local_gas_station,
            onTap: () => _requestAssistance(context, 'EMPTY_FUEL'),
          ),
        ],
      ),
    );
  }

  void _requestAssistance(BuildContext context, String issue) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (!auth.isAuthenticated) {
      Navigator.pushNamed(context, AppRoutes.phoneEntry);
      return;
    }

    final provider = Provider.of<RoadsideProvider>(context, listen: false);
    // Mock location
    final success = await provider.requestAssistance(issue, 'Current Location', 31.5204, 74.3587);
    if (success && context.mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.providerSearching);
    }
  }
}
