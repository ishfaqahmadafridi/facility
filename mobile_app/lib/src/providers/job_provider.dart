import 'package:flutter/material.dart';
import '../../services/job_api.dart';
import '../../../models/job_model.dart';

class JobProvider extends ChangeNotifier {
  final JobApi _jobApi = JobApi();

  List<JobModel> _jobs = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<JobModel> get jobs => _jobs;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchJobs() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _jobs = await _jobApi.getJobs();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
