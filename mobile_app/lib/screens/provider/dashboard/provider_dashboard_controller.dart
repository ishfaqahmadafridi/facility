import 'package:flutter/material.dart';
import 'package:facility/services/api_service.dart';
import '../../communication/job_chat_view.dart';
import '../../communication/voice_call_view.dart';
import '../../../core/utils/snackbar_utils.dart';

/// Controller for Provider Dashboard View.
class ProviderDashboardController {
  bool isOnline = false;
  bool isLoading = true;
  double radius = 15.0;
  List<dynamic> availableJobs = [];
  List<dynamic> activeJobs = [];

  Future<void> fetchData(VoidCallback onStateUpdate) async {
    isLoading = true;
    onStateUpdate();

    try {
      final profile = await ApiService.instance.getMyProviderProfile();
      final jobs = await ApiService.instance.getJobs();
      final activeData = await ApiService.instance.getActiveAssignments();

      isOnline = profile?['is_online'] == true;
      availableJobs = jobs;
      activeJobs = (activeData?['jobs'] as List?) ?? [];
    } catch (_) {
      // Ignore errors, stop loading
    } finally {
      isLoading = false;
      onStateUpdate();
    }
  }

  Future<void> toggleOnline(BuildContext context, bool value, VoidCallback onStateUpdate) async {
    final success = await ApiService.instance.toggleOnline(value);

    if (context.mounted) {
      if (success) {
        isOnline = value;
        onStateUpdate();
        SnackbarUtils.showSuccess(context, value ? 'You are now Online!' : 'You are now Offline.');
        fetchData(onStateUpdate);
      } else {
        SnackbarUtils.showError(context, 'Failed to update online status.');
      }
    }
  }

  Future<void> acceptJob(BuildContext context, Map<String, dynamic> job, VoidCallback onStateUpdate) async {
    final jobId = job['id']?.toString() ?? '';
    if (jobId.isEmpty) return;

    final success = await ApiService.instance.acceptJob(jobId);

    if (context.mounted) {
      if (success) {
        SnackbarUtils.showSuccess(context, 'Job accepted!');
        fetchData(onStateUpdate);
      } else {
        SnackbarUtils.showError(context, 'Failed to accept job.');
      }
    }
  }

  void openChat(BuildContext context, Map<String, dynamic> job) {
    final jobId = job['id']?.toString() ?? '';
    if (jobId.isEmpty) return;
    final title = job['title']?.toString() ?? 'Job Chat';
    Navigator.push(context, MaterialPageRoute(builder: (_) => JobChatView(jobId: jobId, title: title)));
  }

  void openCall(BuildContext context, Map<String, dynamic> job) {
    final jobId = job['id']?.toString() ?? '';
    if (jobId.isEmpty) return;
    final title = job['title']?.toString() ?? 'Voice Call';
    Navigator.push(context, MaterialPageRoute(builder: (_) => VoiceCallView(jobId: jobId, title: title)));
  }

  void updateRadius(double newRadius, VoidCallback onStateUpdate) {
    radius = newRadius;
    onStateUpdate();
  }
}
