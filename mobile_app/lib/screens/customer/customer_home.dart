import 'package:flutter/material.dart';

import 'customer_bookings/customer_bookings_view.dart';
import 'customer_dashboard/customer_dashboard_view.dart';
import 'profile/customer_profile_view.dart';
import 'widgets/customer_app_bar.dart';
import 'widgets/customer_bottom_nav.dart';
import 'widgets/sos_dialog.dart';
import 'customer_home_controller.dart';

class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key});

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  final _controller = CustomerHomeController();

  final List<Widget> _pages = const [
    CustomerDashboardView(),
    CustomerBookingsView(),
    CustomerProfileView(),
  ];

  Future<void> _showSOSDialog() async {
    await showDialog(
      context: context,
      builder: (context) => SOSDialog(
        onSubmit: _controller.triggerSOS,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomerAppBar(),
      body: IndexedStack(
        index: _controller.selectedIndex,
        children: _pages,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        onPressed: _showSOSDialog,
        icon: const Icon(Icons.warning_rounded),
        label: const Text('SOS'),
      ),
      bottomNavigationBar: CustomerBottomNav(
        currentIndex: _controller.selectedIndex,
        onTap: (index) => _controller.onItemTapped(index, () {
          if (mounted) setState(() {});
        }),
      ),
    );
  }
}
