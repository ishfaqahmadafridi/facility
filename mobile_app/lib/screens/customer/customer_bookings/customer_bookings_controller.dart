import 'package:flutter/material.dart';

import 'package:facility/services/api_service.dart';
import '../../communication/job_chat_view.dart';
import '../../communication/voice_call_view.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../core/constants/app_strings.dart';

/// Controller for Customer Bookings View.
class CustomerBookingsController {
  bool isLoading = true;
  List<dynamic> jobs = [];
  List<dynamic> rides = [];
  List<dynamic> historyJobs = [];

  Future<void> fetchData(VoidCallback onStateUpdate) async {
    isLoading = true;
    onStateUpdate();

    try {
      final activeData = await ApiService.instance.getActiveAssignments();
      final history = await ApiService.instance.getJobHistory();

      jobs = (activeData?['jobs'] as List<dynamic>?) ?? [];
      rides = (activeData?['rides'] as List<dynamic>?) ?? [];
      historyJobs = history;
    } catch (e) {
      // Ignore errors for now, just stop loading
    } finally {
      isLoading = false;
      onStateUpdate();
    }
  }

  void openChat(BuildContext context, Map<String, dynamic> job) {
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

  void openCall(BuildContext context, Map<String, dynamic> job) {
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

  Future<bool> submitReport(BuildContext context, String jobId, String description) async {
    if (description.trim().isEmpty) {
      SnackbarUtils.showError(context, AppStrings.enterIssueDetails);
      return false;
    }

    final success = await ApiService.instance.reportIssue(
      jobId: jobId,
      description: description.trim(),
    );

    if (context.mounted) {
      if (success) {
        SnackbarUtils.showSuccess(context, AppStrings.issueReported);
      } else {
        SnackbarUtils.showError(context, AppStrings.issueReportFailed);
      }
    }
    return success;
  }
}
