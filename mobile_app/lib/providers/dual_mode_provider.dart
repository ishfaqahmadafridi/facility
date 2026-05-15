import 'package:flutter/material.dart';

enum AppMode { customer, provider }

class DualModeProvider with ChangeNotifier {
  AppMode _activeMode = AppMode.customer;

  AppMode get activeMode => _activeMode;

  bool get isCustomerMode => _activeMode == AppMode.customer;
  bool get isProviderMode => _activeMode == AppMode.provider;

  void toggleMode() {
    _activeMode = _activeMode == AppMode.customer 
        ? AppMode.provider 
        : AppMode.customer;
    notifyListeners();
  }

  void setMode(AppMode mode) {
    if (_activeMode != mode) {
      _activeMode = mode;
      notifyListeners();
    }
  }
}
