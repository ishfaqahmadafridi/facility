import 'package:flutter/material.dart';
import '../../../../config/routes.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../common_widgets/app_button.dart';

class RideMapScreen extends StatefulWidget {
  const RideMapScreen({super.key});

  @override
  State<RideMapScreen> createState() => _RideMapScreenState();
}

class _RideMapScreenState extends State<RideMapScreen> {
  int _selectedService = 0;

  final List<_RideServiceItem> _services = const [
    _RideServiceItem(title: 'Motor', subtitle: 'PKR 150 - 350', icon: Icons.two_wheeler),
    _RideServiceItem(title: 'Cargo', subtitle: 'PKR 700 - 2,000', icon: Icons.local_shipping_outlined),
    _RideServiceItem(title: 'Auto', subtitle: 'PKR 250 - 500', icon: Icons.electric_rickshaw_outlined),
    _RideServiceItem(title: 'Ride Pool', subtitle: 'PKR 200 - 400', icon: Icons.groups_2_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF061629), Color(0xFF0A1D36), Color(0xFF051322)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
                child: Row(
                  children: [
                    Material(
                      color: AppColors.bgCard.withValues(alpha: 0.95),
                      shape: const CircleBorder(),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                        decoration: BoxDecoration(
                          color: AppColors.bgCard.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.my_location, color: AppColors.info, size: 16),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'My location is visible',
                                style: TextStyle(color: AppColors.textPrimary, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Material(
                      color: AppColors.bgCard.withValues(alpha: 0.95),
                      shape: const CircleBorder(),
                      child: IconButton(
                        icon: const Icon(Icons.notifications_outlined, color: AppColors.warning),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                  padding: const EdgeInsets.fromLTRB(12, 14, 12, 0),
                  decoration: const BoxDecoration(
                    color: Color(0x0Fffffff),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Hello, Ali', style: AppTextStyles.bodySmall),
                      const SizedBox(height: 4),
                      const Text('Where are you going?', style: AppTextStyles.h1),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, AppRoutes.pickDrop),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.bgCard,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.neutral700),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.search, color: AppColors.textSecondary, size: 18),
                              SizedBox(width: 10),
                              Text('Enter your destination', style: AppTextStyles.bodySecondary),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _services.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 1.35,
                              ),
                              itemBuilder: (context, index) {
                                final service = _services[index];
                                final selected = _selectedService == index;
                                return GestureDetector(
                                  onTap: () => setState(() => _selectedService = index),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.bgCard,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: selected ? const Color(0xFFB7FF2A) : AppColors.neutral700,
                                        width: selected ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(service.icon, size: 28, color: AppColors.white),
                                        const SizedBox(height: 8),
                                        Text(service.title, style: AppTextStyles.h3),
                                        Text(service.subtitle, style: AppTextStyles.bodySmall),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.bgCard,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.neutral700),
                              ),
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Suggest your fare', style: AppTextStyles.h3),
                                        SizedBox(height: 2),
                                        Text('Negotiate and save more', style: AppTextStyles.bodySmall),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFB7FF2A).withValues(alpha: 0.18),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Icons.local_offer, color: Color(0xFFB7FF2A)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.bgCard,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.neutral700),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Recent Places', style: AppTextStyles.h3),
                                      Text('See all', style: AppTextStyles.bodySmall),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  _recentPlaceTile('Home', 'Bahria Town, Lahore'),
                                  const SizedBox(height: 8),
                                  _recentPlaceTile('Work', 'Gulberg III, Lahore'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            AppButton(
                              label: 'Set Pickup & Destination',
                              onPressed: () => Navigator.pushNamed(context, AppRoutes.pickDrop),
                              prefixIcon: Icons.navigation_rounded,
                            ),
                            const SizedBox(height: 14),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.neutral700),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _BottomNavItem(icon: Icons.home_filled, label: 'Home', active: true),
                    _BottomNavItem(icon: Icons.directions_car_filled_outlined, label: 'My Rides'),
                    _BottomNavItem(icon: Icons.account_balance_wallet_outlined, label: 'Wallet'),
                    _BottomNavItem(icon: Icons.person_outline, label: 'Profile'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _recentPlaceTile(String title, String subtitle) {
    return Row(
      children: [
        const Icon(Icons.place_outlined, color: AppColors.neutral400, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.body),
              Text(subtitle, style: AppTextStyles.bodySmall),
            ],
          ),
        ),
        const Icon(Icons.star_border, color: AppColors.neutral400, size: 18),
      ],
    );
  }
}

class _RideServiceItem {
  final String title;
  final String subtitle;
  final IconData icon;

  const _RideServiceItem({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFFB7FF2A) : AppColors.neutral400;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: color, fontSize: 11, fontWeight: active ? FontWeight.w700 : FontWeight.w500),
        ),
      ],
    );
  }
}
