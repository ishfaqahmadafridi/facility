import 'package:flutter/material.dart';
import 'components/bookings_placeholder.dart';

class CustomerBookingsView extends StatelessWidget {
  const CustomerBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: BookingsPlaceholder(),
    );
  }
}
