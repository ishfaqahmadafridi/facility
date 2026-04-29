// lib/src/modules/home/providers/home_provider.dart
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  // This provider will manage the state of the home screen,
  // like fetching active jobs, current promotions, etc.
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchHomeData() async {
    _isLoading = true;
    notifyListeners();
    
    // Simulate fetching data
    await Future.delayed(const Duration(seconds: 1));
    
    _isLoading = false;
    notifyListeners();
  }
}
