import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Provider-mode bottom navigation bar.
class ProviderBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const ProviderBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: AppColors.providerPrimary,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Jobs'),
        BottomNavigationBarItem(icon: Icon(Icons.directions_bike), label: 'Rides'),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Earnings'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
