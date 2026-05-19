import 'package:flutter/material.dart';
import 'package:facility/services/api_service.dart';

/// Controller for CustomerHome. Manages bottom navigation state and SOS API calls.
class CustomerHomeController {
  int selectedIndex = 0;

  void onItemTapped(int index, VoidCallback onStateUpdate) {
    selectedIndex = index;
    onStateUpdate();
  }

  Future<bool> triggerSOS(bool shareWithPolice, String notes) async {
    return await ApiService.instance.triggerSOS(
      latitude: 33.6844,
      longitude: 73.0479,
      sharedWithPolice: shareWithPolice,
      notes: notes,
    );
  }
}
