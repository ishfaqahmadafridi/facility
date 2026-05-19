import 'package:flutter/material.dart';

import '../dashboard/customer_dashboard_components/header.dart';
import '../dashboard/customer_dashboard_components/category_carousel.dart';
import '../dashboard/customer_dashboard_components/radius_filter.dart';
import '../dashboard/customer_dashboard_components/providers_list.dart';
import '../dashboard/customer_dashboard_components/provider_card.dart';
import 'customer_dashboard_controller.dart';
import '../../../shared/widgets/loading_overlay.dart';

class CustomerDashboardView extends StatefulWidget {
  const CustomerDashboardView({super.key});

  @override
  State<CustomerDashboardView> createState() => _CustomerDashboardViewState();
}

class _CustomerDashboardViewState extends State<CustomerDashboardView> {
  final _controller = CustomerDashboardController();

  @override
  void initState() {
    super.initState();
    _controller.fetchData(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.isLoading) return const LoadingOverlay();

    return RefreshIndicator(
      onRefresh: () => _controller.fetchData(() {
        if (mounted) setState(() {});
      }),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DashboardHeader(),
            CategoryCarousel(
              categories: _controller.categories,
              selected: _controller.selectedCategory,
              onSelect: (s) => _controller.updateFilters(
                category: s,
                onStateUpdate: () {
                  if (mounted) setState(() {});
                },
              ),
              onRidesTap: () => _controller.openRideRequest(context),
            ),
            const Divider(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Services Near Me',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  RadiusFilter(
                    value: _controller.radius,
                    womenOnly: _controller.womenOnly,
                    onChanged: (v) => _controller.updateFilters(
                      newRadius: v,
                      onStateUpdate: () {
                        if (mounted) setState(() {});
                      },
                    ),
                    onWomenOnlyChanged: (b) => _controller.updateFilters(
                      newWomenOnly: b,
                      onStateUpdate: () {
                        if (mounted) setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
            ProvidersList(
              providers: _controller.nearbyProviders,
              itemBuilder: (provider) => ProviderCard(
                provider: provider,
                onTap: () => _controller.openProvider(context, provider),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
