// lib/src/modules/nurses/providers/nurse_provider.dart
import 'package:flutter/material.dart';

class NurseProvider extends ChangeNotifier {
  // Medical-specific state management, e.g. selecting IV Drip vs General Checkup
  
  String? _selectedServiceType;
  String? get selectedServiceType => _selectedServiceType;

  void selectService(String type) {
    _selectedServiceType = type;
    notifyListeners();
  }
}
