import 'package:flutter/material.dart';

import 'provider_dashboard_components/top_controls.dart';
import 'provider_dashboard_components/section_title.dart';
import 'provider_dashboard_components/jobs_list.dart';
import 'provider_dashboard_components/active_jobs_list.dart';
import 'provider_dashboard_controller.dart';
import '../../../shared/widgets/loading_overlay.dart';

class ProviderDashboardView extends StatefulWidget {
  const ProviderDashboardView({super.key});

  @override
  State<ProviderDashboardView> createState() => _ProviderDashboardViewState();
}

class _ProviderDashboardViewState extends State<ProviderDashboardView> {
  final _controller = ProviderDashboardController();

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
        children: [
          TopControls(
            isOnline: _controller.isOnline,
            radius: _controller.radius,
            onToggle: (v) => _controller.toggleOnline(context, v, () {
              if (mounted) setState(() {});
            }),
            onRadiusChanged: (v) {
              if (v != null) {
                _controller.updateRadius(v, () {
                  if (mounted) setState(() {});
                });
              }
            },
          ),
          const Divider(),
          const SectionTitle('Jobs Available Near You'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: JobsList(
              jobs: _controller.availableJobs,
              onAccept: (job) => _controller.acceptJob(context, job, () {
                if (mounted) setState(() {});
              }),
            ),
          ),
          const Divider(height: 32),
          const SectionTitle('Active Assignments'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ActiveJobsList(
              jobs: _controller.activeJobs,
              onChat: (job) => _controller.openChat(context, job),
              onCall: (job) => _controller.openCall(context, job),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
