import 'package:flutter/material.dart';

import '../../../services/api_service.dart';
import '../../communication/job_chat_view.dart';
import '../../communication/voice_call_view.dart';
import 'customer_bookings_components/part2/section_title.dart';
import 'customer_bookings_components/part2/ride_card.dart';
import 'customer_bookings_components/part3/section_title.dart' as history_titles;
import 'customer_bookings_components/part3/history_card.dart';

class CustomerBookingsView extends StatefulWidget {
  const CustomerBookingsView({super.key});

  @override
  State<CustomerBookingsView> createState() => _CustomerBookingsViewState();
}

class _CustomerBookingsViewState extends State<CustomerBookingsView> {
  List<dynamic> _jobs = [];
  List<dynamic> _rides = [];
  List<dynamic> _historyJobs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    final activeData = await ApiService.instance.getActiveAssignments();
    final historyJobs = await ApiService.instance.getJobHistory();
    if (!mounted) return;

    setState(() {
      _jobs = (activeData?['jobs'] as List<dynamic>?) ?? [];
      _rides = (activeData?['rides'] as List<dynamic>?) ?? [];
      _historyJobs = historyJobs;
      _isLoading = false;
    });
  }

  void _openChat(Map<String, dynamic> job) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JobChatView(
          jobId: job['id'].toString(),
          title: job['title']?.toString() ?? 'Job Chat',
        ),
      ),
    );
  }

  void _openCall(Map<String, dynamic> job) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VoiceCallView(
          jobId: job['id'].toString(),
          title: job['title']?.toString() ?? 'Voice Call',
        ),
      ),
    );
  }

  Future<void> _showReportIssueDialog(Map<String, dynamic> job) async {
    final controller = TextEditingController();
    bool isSubmitting = false;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Report Issue'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Describe the dispute or safety issue from this completed job.'),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller,
                    minLines: 4,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      hintText: 'Explain what went wrong...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          if (controller.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please enter the issue details.')),
                            );
                            return;
                          }
                          setDialogState(() => isSubmitting = true);
                          final success = await ApiService.instance.reportIssue(
                            jobId: job['id'].toString(),
                            description: controller.text.trim(),
                          );
                          if (!mounted) return;
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(success ? 'Issue reported successfully.' : 'Failed to report issue.')),
                          );
                          if (success) {
                            _fetchData();
                          }
                        },
                  child: isSubmitting
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Submit Report'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    final provider = job['provider'] ?? {};
    final providerUser = provider['user'] ?? {};
    final providerName = providerUser['full_name'] ?? providerUser['phone_number'] ?? 'Assigned provider';
    final status = job['status'] ?? 'PENDING';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job['title']?.toString() ?? 'Service Request', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(job['description']?.toString() ?? 'No description'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoChip(icon: Icons.person_outline, label: providerName),
                _InfoChip(icon: Icons.info_outline, label: status),
                if (job['price'] != null) _InfoChip(icon: Icons.payments_outlined, label: 'Rs ${job['price']}'),
              ],
            ),
            if (provider['id'] != null) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _openChat(job),
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: const Text('Chat'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _openCall(job),
                      icon: const Icon(Icons.call),
                      label: const Text('Call'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRideCard(Map<String, dynamic> ride) {
    final status = ride['status']?.toString() ?? 'PENDING';
    final rider = ride['rider'] ?? {};
    final riderUser = rider['user'] ?? {};
    final riderName = riderUser['full_name'] ?? riderUser['phone_number'] ?? 'Waiting for riders';
    final agreedFare = ride['agreed_fare'];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Ride to ${ride['dropoff_address'] ?? 'destination'}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                Text(status, style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 10),
            Text('Pickup: ${ride['pickup_address'] ?? 'Unknown'}'),
            const SizedBox(height: 6),
            Text('Rider: $riderName'),
            const SizedBox(height: 6),
            Text(
              agreedFare != null
                  ? 'Counter-offer: Rs $agreedFare'
                  : 'Suggested fare: Rs ${ride['suggested_fare'] ?? '0'}',
            ),
            if (status == 'COUNTERED') ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final success = await ApiService.instance.declineCounterOffer(ride['id'].toString());
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(success ? 'Counter-offer declined.' : 'Failed to decline offer.')),
                        );
                        if (success) {
                          _fetchData();
                        }
                      },
                      child: const Text('Decline'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final success = await ApiService.instance.acceptCounterOffer(ride['id'].toString());
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(success ? 'Counter-offer accepted.' : 'Failed to accept offer.')),
                        );
                        if (success) {
                          _fetchData();
                        }
                      },
                      child: const Text('Accept Offer'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> job) {
    final provider = job['provider'] ?? {};
    final providerUser = provider['user'] ?? {};
    final providerName = providerUser['full_name'] ?? providerUser['phone_number'] ?? 'Provider';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    job['title']?.toString() ?? 'Completed Job',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                Text(job['status']?.toString() ?? 'COMPLETED'),
              ],
            ),
            const SizedBox(height: 8),
            Text(providerName.toString()),
            const SizedBox(height: 6),
            Text(job['description']?.toString() ?? 'No description'),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showReportIssueDialog(job),
                icon: const Icon(Icons.report_gmailerrorred),
                label: const Text('Report Issue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _fetchData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionTitle2('Active Jobs'),
          const SizedBox(height: 12),
          if (_jobs.isEmpty)
            const Text('No active job conversations yet.', style: TextStyle(color: Colors.grey))
          else
            ..._jobs.map((job) => _buildJobCard((job as Map).cast<String, dynamic>())),
          const SizedBox(height: 24),
          SectionTitle2('Active Rides'),
          const SizedBox(height: 12),
          if (_rides.isEmpty)
            const Text('No active rides right now.', style: TextStyle(color: Colors.grey))
          else
            ..._rides.map((ride) => RideCard2(ride: (ride as Map).cast<String, dynamic>())),
          const SizedBox(height: 24),
          history_titles.SectionTitle3('Completed & Disputed Jobs'),
          const SizedBox(height: 12),
          if (_historyJobs.isEmpty)
            const Text('No completed jobs available for dispute reporting.', style: TextStyle(color: Colors.grey))
          else
            ..._historyJobs.map((job) => HistoryCard3(item: (job as Map).cast<String, dynamic>())),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade700),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}
