import 'package:flutter/material.dart';

import '../../../../services/api_service.dart';
import 'header.dart';
import 'loading.dart';
import 'rider_off.dart';
import 'no_rides.dart';
import 'rides_list.dart';
import 'ride_card_wrapper.dart';

class ProviderRidesFeedView extends StatefulWidget {
  const ProviderRidesFeedView({super.key});

  @override
  State<ProviderRidesFeedView> createState() => _ProviderRidesFeedViewState();
}

class _ProviderRidesFeedViewState extends State<ProviderRidesFeedView> {
  List<dynamic> _rides = [];
  bool _isLoading = true;
  bool _isRiderMode = false;

  @override
  void initState() {
    super.initState();
    _loadRiderModeAndRides();
  }

  Future<void> _loadRiderModeAndRides() async {
    setState(() => _isLoading = true);
    try {
      final profile = await ApiService.instance.getMyProviderProfile();
      final riderMode = profile?['is_rider_mode'] == true;
      List<dynamic> rides = [];
      if (riderMode) {
        rides = await ApiService.instance.getAvailableRides();
      }

      if (mounted) {
        setState(() {
          _isRiderMode = riderMode;
          _rides = rides;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleRiderMode(bool value) async {
    final success = await ApiService.instance.toggleRiderMode(value);
    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update Rider Mode.')),
      );
      return;
    }

    setState(() => _isRiderMode = value);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(value ? 'Rider Mode enabled.' : 'Rider Mode disabled.')),
    );
    await _loadRiderModeAndRides();
  }

  Future<void> _fetchRides() async {
    if (!_isRiderMode) return;
    setState(() => _isLoading = true);
    try {
      final rides = await ApiService.instance.getAvailableRides();
      if (mounted) {
        setState(() {
          _rides = rides;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showCounterOfferDialog(String rideId, num suggestedFare) {
    final bidController = TextEditingController(text: suggestedFare.toStringAsFixed(0));

    showDialog(
      context: context,
      builder: (context) {
        bool isProcessing = false;
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Send Counter Offer'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Enter the fare you want to offer for this ride.'),
                  const SizedBox(height: 16),
                  TextField(
                    controller: bidController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      prefixText: 'Rs. ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                  onPressed: isProcessing
                      ? null
                      : () async {
                          setStateDialog(() => isProcessing = true);
                          final amount = num.tryParse(bidController.text);
                          if (amount == null || amount <= 0) {
                            setStateDialog(() => isProcessing = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Enter a valid offer amount.')),
                            );
                            return;
                          }
                          final success = await ApiService.instance.counterOfferRide(rideId, amount);
                          if (!mounted) return;
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(success ? 'Counter-offer sent for customer approval.' : 'Failed to send counter-offer.'),
                            ),
                          );
                          if (success) {
                            _fetchRides();
                          }
                        },
                  child: isProcessing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Send Offer'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _acceptRide(String rideId) async {
    final success = await ApiService.instance.acceptRide(rideId);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? 'Ride accepted at the suggested fare.' : 'Failed to accept ride.')),
    );
    if (success) {
      _fetchRides();
    }
  }

  Widget _buildHeader() {
    return HeaderContainer(
      isRiderMode: _isRiderMode,
      onToggle: _toggleRiderMode,
      description: _isRiderMode
          ? 'You are visible for transport requests. Nearby customers can send you ride requests now.'
          : 'Enable Rider Mode to receive ride requests as a rider instead of a general service provider.',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const LoadingView();
    }

    return RefreshIndicator(
      onRefresh: _loadRiderModeAndRides,
      child: ListView(
        children: [
          _buildHeader(),
          if (!_isRiderMode)
            const RiderOffView()
          else if (_rides.isEmpty)
            const NoRidesView()
          else
            RidesListView(
              rides: _rides,
              itemBuilder: (rideData) => RideCard(
                ride: (rideData as Map).cast<String, dynamic>(),
                onCounter: (id, fare) => _showCounterOfferDialog(id, fare),
                onAccept: (id) => _acceptRide(id),
              ),
            ),
        ],
      ),
    );
  }
}
