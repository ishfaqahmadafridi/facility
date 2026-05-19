import 'package:flutter/material.dart';

import 'dashboard/provider_dashboard_view.dart';
import 'earnings/provider_earnings_view.dart';
import 'rides/provider_rides_feed_view.dart';
import 'widgets/provider_app_bar.dart';
import 'widgets/provider_bottom_nav.dart';
import 'widgets/provider_profile_tab.dart';

/// Shell screen for the provider mode — app bar, tabs, navigation.
class ProviderHome extends StatefulWidget {
  const ProviderHome({super.key});

  @override
  State<ProviderHome> createState() => _ProviderHomeState();
}

class _ProviderHomeState extends State<ProviderHome> {
  int _currentIndex = 0;

  static const _tabs = <Widget>[
    ProviderDashboardView(),
    ProviderRidesFeedView(),
    ProviderEarningsView(),
    ProviderProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ProviderAppBar(),
      body: _tabs[_currentIndex],
      bottomNavigationBar: ProviderBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}
