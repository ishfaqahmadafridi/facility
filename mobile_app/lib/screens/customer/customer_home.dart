import 'package:flutter/material.dart';
import 'dashboard/customer_dashboard_view.dart';
import 'bookings/customer_bookings_view.dart';
import 'profile/customer_profile_view.dart';
import 'widgets/customer_app_bar.dart';
import 'widgets/customer_bottom_nav.dart';

class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key});

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    CustomerDashboardView(),
    CustomerBookingsView(),
    CustomerProfileView(),
  ];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomerAppBar(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomerBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
