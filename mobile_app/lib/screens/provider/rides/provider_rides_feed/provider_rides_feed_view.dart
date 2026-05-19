import 'package:flutter/material.dart';

import 'header.dart';
import 'loading.dart';
import 'rider_off.dart';
import 'no_rides.dart';
import 'rides_list.dart';
import 'ride_card_wrapper.dart';
import 'provider_rides_feed_controller.dart';
import 'widgets/counter_offer_dialog.dart';

class ProviderRidesFeedView extends StatefulWidget {
  const ProviderRidesFeedView({super.key});

  @override
  State<ProviderRidesFeedView> createState() => _ProviderRidesFeedViewState();
}

class _ProviderRidesFeedViewState extends State<ProviderRidesFeedView> {
  final _controller = ProviderRidesFeedController();

  @override
  void initState() {
    super.initState();
    _controller.loadRiderModeAndRides(() {
      if (mounted) setState(() {});
    });
  }

  Future<void> _showCounterOfferDialog(String rideId, num suggestedFare) async {
    final success = await showDialog<bool>(
      context: context,
      builder: (context) => CounterOfferDialog(
        initialFare: suggestedFare,
        onSubmit: (amount) => _controller.sendCounterOffer(context, rideId, amount),
      ),
    );

    if (success == true) {
      _controller.fetchRides(() {
        if (mounted) setState(() {});
      });
    }
  }

  Widget _buildHeader() {
    return HeaderContainer(
      isRiderMode: _controller.isRiderMode,
      onToggle: (v) => _controller.toggleRiderMode(context, v, () {
        if (mounted) setState(() {});
      }),
      description: _controller.isRiderMode
          ? 'You are visible for transport requests. Nearby customers can send you ride requests now.'
          : 'Enable Rider Mode to receive ride requests as a rider instead of a general service provider.',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.isLoading) {
      return const LoadingView();
    }

    return RefreshIndicator(
      onRefresh: () => _controller.loadRiderModeAndRides(() {
        if (mounted) setState(() {});
      }),
      child: ListView(
        children: [
          _buildHeader(),
          if (!_controller.isRiderMode)
            const RiderOffView()
          else if (_controller.rides.isEmpty)
            const NoRidesView()
          else
            RidesListView(
              rides: _controller.rides,
              itemBuilder: (rideData) => RideCard(
                ride: (rideData as Map).cast<String, dynamic>(),
                onCounter: _showCounterOfferDialog,
                onAccept: (id) => _controller.acceptRide(context, id, () {
                  if (mounted) setState(() {});
                }),
              ),
            ),
        ],
      ),
    );
  }
}
