import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';

class SubscriptionPlansScreen extends StatelessWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(title: const Text('Premium Care Plans')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('Choose a plan for ongoing medical care.', style: AppTextStyles.h2),
          const SizedBox(height: 24),
          _buildPlanCard(
            context,
            name: 'Basic Elderly Care',
            price: 'Rs. 15,000 / month',
            visits: '4 Visits (1/week)',
            features: ['General checkups', 'Vitals monitoring', 'Medication management'],
            isPopular: false,
          ),
          const SizedBox(height: 16),
          _buildPlanCard(
            context,
            name: 'Intensive Post-Op Care',
            price: 'Rs. 35,000 / month',
            visits: '12 Visits (3/week)',
            features: ['Wound dressing', 'IV Drip administration', 'Direct doctor reporting'],
            isPopular: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, {required String name, required String price, required String visits, required List<String> features, required bool isPopular}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isPopular ? AppColors.primary : AppColors.neutral700, width: isPopular ? 2 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isPopular)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: const Text('MOST POPULAR', textAlign: TextAlign.center, style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.h2),
                const SizedBox(height: 8),
                Text(price, style: const TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text(visits, style: AppTextStyles.h3),
                const SizedBox(height: 16),
                ...features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: AppColors.success, size: 20),
                      const SizedBox(width: 12),
                      Text(f, style: AppTextStyles.body),
                    ],
                  ),
                )),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPopular ? AppColors.primary : AppColors.neutral700,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Subscribe Now', style: TextStyle(color: AppColors.white)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
