import 'package:flutter/material.dart';

import '../bookings/customer_bookings_components/part2/section_title.dart';
import '../bookings/customer_bookings_components/part2/ride_card.dart';
import '../bookings/customer_bookings_components/part3/section_title.dart' as history_titles;
import '../bookings/customer_bookings_components/part3/history_card.dart';
import 'customer_bookings_components_extra/booking_component_01.dart';
import 'customer_bookings_components_extra/booking_component_02.dart';
import 'customer_bookings_components_extra/booking_component_03.dart';
import 'customer_bookings_components_extra/booking_component_04.dart';
import 'customer_bookings_components_extra/booking_component_05.dart';
import 'customer_bookings_components_extra/booking_component_06.dart';
import 'customer_bookings_components_extra/booking_component_07.dart';
import 'customer_bookings_components_extra/booking_component_08.dart';
import 'customer_bookings_components_extra/booking_component_09.dart';
import 'customer_bookings_components_extra/booking_component_10.dart';
import 'customer_bookings_components_extra/booking_component_11.dart';
import 'customer_bookings_components_extra/booking_component_12.dart';
import 'customer_bookings_components_extra/booking_component_13.dart';
import 'customer_bookings_components_extra/booking_component_14.dart';
import 'customer_bookings_components_extra/booking_component_15.dart';
import 'customer_bookings_components_extra/booking_component_16.dart';
import 'customer_bookings_components_extra/booking_component_17.dart';
import 'customer_bookings_components_extra/booking_component_18.dart';
import 'customer_bookings_components_extra/booking_component_19.dart';
import 'customer_bookings_components_extra/booking_component_20.dart';
import 'customer_bookings_components_extra/booking_component_21.dart';
import 'customer_bookings_components_extra/booking_component_22.dart';
import 'customer_bookings_components_extra/booking_component_23.dart';
import 'customer_bookings_components_extra/booking_component_24.dart';
import 'customer_bookings_components_extra/booking_component_25.dart';

import 'customer_bookings_controller.dart';
import 'widgets/active_job_card.dart';
import '../../../../shared/widgets/loading_overlay.dart';

class CustomerBookingsView extends StatefulWidget {
  const CustomerBookingsView({super.key});

  @override
  State<CustomerBookingsView> createState() => _CustomerBookingsViewState();
}

class _CustomerBookingsViewState extends State<CustomerBookingsView> {
  final _controller = CustomerBookingsController();

  @override
  void initState() {
    super.initState();
    _controller.fetchData(() {
      if (mounted) setState(() {});
    });
  }



  @override
  Widget build(BuildContext context) {
    if (_controller.isLoading) {
      return const LoadingOverlay();
    }

    return RefreshIndicator(
      onRefresh: () => _controller.fetchData(() {
        if (mounted) setState(() {});
      }),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionTitle2('Active Jobs'),
          const SizedBox(height: 12),
          if (_controller.jobs.isEmpty)
            const Text('No active job conversations yet.', style: TextStyle(color: Colors.grey))
          else
            ..._controller.jobs.map((job) => ActiveJobCard(
                  job: (job as Map).cast<String, dynamic>(),
                  onChat: () => _controller.openChat(context, job.cast<String, dynamic>()),
                  onCall: () => _controller.openCall(context, job.cast<String, dynamic>()),
                )),
          const SizedBox(height: 24),
          SectionTitle2('Active Rides'),
          const SizedBox(height: 12),
          if (_controller.rides.isEmpty)
            const Text('No active rides right now.', style: TextStyle(color: Colors.grey))
          else
            ..._controller.rides.map((ride) => RideCard2(ride: (ride as Map).cast<String, dynamic>())),
          const SizedBox(height: 24),
          history_titles.SectionTitle3('Completed & Disputed Jobs'),
          const SizedBox(height: 12),
          if (_controller.historyJobs.isEmpty)
            const Text('No completed jobs available for dispute reporting.', style: TextStyle(color: Colors.grey))
          else
            ..._controller.historyJobs.map((job) => HistoryCard3(item: (job as Map).cast<String, dynamic>())),
          const SizedBox(height: 24),
          SectionTitle2('Extras'),
          const SizedBox(height: 12),
          const BookingComponent01(),
          const BookingComponent02(),
          const BookingComponent03(),
          const BookingComponent04(),
          const BookingComponent05(),
          const BookingComponent06(),
          const BookingComponent07(),
          const BookingComponent08(),
          const BookingComponent09(),
          const BookingComponent10(),
          const BookingComponent11(),
          const BookingComponent12(),
          const BookingComponent13(),
          const BookingComponent14(),
          const BookingComponent15(),
          const BookingComponent16(),
          const BookingComponent17(),
          const BookingComponent18(),
          const BookingComponent19(),
          const BookingComponent20(),
          const BookingComponent21(),
          const BookingComponent22(),
          const BookingComponent23(),
          const BookingComponent24(),
          const BookingComponent25(),
        ],
      ),
    );
  }
}
