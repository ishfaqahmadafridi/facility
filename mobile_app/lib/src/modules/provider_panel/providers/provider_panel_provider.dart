import 'package:flutter/material.dart';

class ProviderPanelProvider extends ChangeNotifier {
  bool _isOnline = false;
  bool get isOnline => _isOnline;

  List<Map<String, dynamic>> _incomingJobs = [];
  List<Map<String, dynamic>> get incomingJobs => _incomingJobs;

  void toggleOnlineStatus() {
    _isOnline = !_isOnline;
    notifyListeners();
    // In a real app, this would trigger LocationProvider to start/stop broadcasting to Redis
  }

  void addIncomingJob(Map<String, dynamic> job) {
    _incomingJobs.insert(0, job);
    notifyListeners();
  }

  void acceptJob(String jobId) {
    _incomingJobs.removeWhere((j) => j['id'] == jobId);
    notifyListeners();
    // In a real app, this would call the API to update job status
  }

  void declineJob(String jobId) {
    _incomingJobs.removeWhere((j) => j['id'] == jobId);
    notifyListeners();
  }
}
