import 'package:flutter/material.dart';

import '../../../services/api_service.dart';
import '../booking/provider_profile_view.dart';
import '../dashboard/customer_dashboard_components/header.dart';
import '../dashboard/customer_dashboard_components/category_carousel.dart';
import '../dashboard/customer_dashboard_components/section_title.dart';
import '../dashboard/customer_dashboard_components/radius_filter.dart';
import '../dashboard/customer_dashboard_components/providers_list.dart';
import '../dashboard/customer_dashboard_components/provider_card.dart';
import '../dashboard/customer_dashboard_components/empty_state.dart';

class CustomerDashboardView extends StatefulWidget {
  const CustomerDashboardView({super.key});

  @override
  State<CustomerDashboardView> createState() => _CustomerDashboardViewState();
}

class _CustomerDashboardViewState extends State<CustomerDashboardView> {
  List<dynamic> _categories = [];
  List<dynamic> _nearbyProviders = [];
  bool _isLoading = true;
  String? _selectedCategory;
  double _radius = 10.0;
  bool _womenOnly = false;

  final double _currentLat = 33.6844;
  final double _currentLng = 73.0479;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final categories = await ApiService.instance.getCategories();
      final providers = await ApiService.instance.getProvidersNearby(lat: _currentLat, lng: _currentLng, radius: _radius, category: _selectedCategory, womenOnly: _womenOnly);

      if (mounted) {
        setState(() {
          _categories = categories.isNotEmpty
              ? categories
              : [
                  {'name': 'Home Repair', 'icon': Icons.home_repair_service},
                  {'name': 'Labour', 'icon': Icons.construction},
                  {'name': 'Healthcare', 'icon': Icons.health_and_safety},
                  {'name': 'Beauty', 'icon': Icons.face},
                  {'name': 'Rides', 'icon': Icons.directions_car},
                ];
          _nearbyProviders = providers;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _openProvider(dynamic provider) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProviderProfileView(initialProviderData: provider)));
  }

  void _openRideRequest() {
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return RefreshIndicator(
      onRefresh: _fetchData,
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const DashboardHeader(),
          CategoryCarousel(categories: _categories, selected: _selectedCategory, onSelect: (s) => setState(() => _selectedCategory = s.isEmpty ? null : s), onRidesTap: _openRideRequest),
          const Divider(height: 32),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Services Near Me', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), RadiusFilter(value: _radius, onChanged: (v) => setState(() => _radius = v), onWomenOnlyChanged: (b) => setState(() => _womenOnly = b), womenOnly: _womenOnly)])),
          ProvidersList(providers: _nearbyProviders, itemBuilder: (provider) => ProviderCard(provider: provider, onTap: () => _openProvider(provider))),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }
}
