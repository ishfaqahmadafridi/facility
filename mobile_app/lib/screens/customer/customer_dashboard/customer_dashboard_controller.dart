import 'package:flutter/material.dart';

import 'package:facility/services/api_service.dart';
import '../booking/provider_profile_view.dart';
import '../../../core/constants/app_constants.dart';

/// Controller for Customer Dashboard View.
class CustomerDashboardController {
  List<dynamic> categories = [];
  List<dynamic> nearbyProviders = [];
  bool isLoading = true;
  String? selectedCategory;
  double radius = AppConstants.defaultRadius;
  bool womenOnly = false;

  Future<void> fetchData(VoidCallback onStateUpdate) async {
    isLoading = true;
    onStateUpdate();

    try {
      final cats = await ApiService.instance.getCategories();
      final providers = await ApiService.instance.getProvidersNearby(
        lat: AppConstants.defaultLatitude,
        lng: AppConstants.defaultLongitude,
        radius: radius,
        category: selectedCategory,
        womenOnly: womenOnly,
      );

      categories = cats.isNotEmpty
          ? cats
          : [
              {'name': 'Home Repair', 'icon': Icons.home_repair_service},
              {'name': 'Labour', 'icon': Icons.construction},
              {'name': 'Healthcare', 'icon': Icons.health_and_safety},
              {'name': 'Beauty', 'icon': Icons.face},
              {'name': 'Rides', 'icon': Icons.directions_car},
            ];
      nearbyProviders = providers;
    } catch (_) {
      // Ignore errors, stop loading
    } finally {
      isLoading = false;
      onStateUpdate();
    }
  }

  void openProvider(BuildContext context, dynamic provider) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProviderProfileView(initialProviderData: provider),
      ),
    );
  }

  void openRideRequest(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Ride Request')),
          body: const Center(child: Text('Ride request screen (placeholder)')),
        ),
      ),
    );
  }

  void updateFilters({
    String? category,
    double? newRadius,
    bool? newWomenOnly,
    required VoidCallback onStateUpdate,
  }) {
    if (category != null) selectedCategory = category.isEmpty ? null : category;
    if (newRadius != null) radius = newRadius;
    if (newWomenOnly != null) womenOnly = newWomenOnly;

    fetchData(onStateUpdate);
  }
}
