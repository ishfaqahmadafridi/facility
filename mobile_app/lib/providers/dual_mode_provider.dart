import 'package:flutter/material.dart';
import '../services/api_service.dart';

enum AppMode { customer, provider }

class DualModeProvider with ChangeNotifier {
  AppMode _activeMode = AppMode.customer;

  AppMode get activeMode => _activeMode;

  bool get isCustomerMode => _activeMode == AppMode.customer;
  bool get isProviderMode => _activeMode == AppMode.provider;

  Future<bool> toggleMode() async {
    final newMode = _activeMode == AppMode.customer ? AppMode.provider : AppMode.customer;
    final modeStr = newMode == AppMode.customer ? 'CUSTOMER' : 'PROVIDER';
    
    // Call the backend to persist mode switch
    final success = await ApiService.instance.switchMode(modeStr);
    
    // Switch locally if successful or offline logic fallback
    if (success) {
      _activeMode = newMode;
      notifyListeners();
      return true;
    }
    return false;
  }

  void setMode(AppMode mode) {
    if (_activeMode != mode) {
      _activeMode = mode;
      notifyListeners();
    }
  }
}
