import 'package:flutter/material.dart';

import 'package:facility/services/api_service.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/snackbar_utils.dart';

/// Controller for the Provider Rides Feed.
class ProviderRidesFeedController {
  List<dynamic> rides = [];
  bool isLoading = true;
  bool isRiderMode = false;

  Future<void> loadRiderModeAndRides(VoidCallback onStateUpdate) async {
    isLoading = true;
    onStateUpdate();

    try {
      final profile = await ApiService.instance.getMyProviderProfile();
      final riderMode = profile?['is_rider_mode'] == true;
      List<dynamic> loadedRides = [];
      
      if (riderMode) {
        loadedRides = await ApiService.instance.getAvailableRides();
      }

      isRiderMode = riderMode;
      rides = loadedRides;
    } catch (_) {
      // Ignore errors, stop loading
    } finally {
      isLoading = false;
      onStateUpdate();
    }
  }

  Future<void> toggleRiderMode(BuildContext context, bool value, VoidCallback onStateUpdate) async {
    final success = await ApiService.instance.toggleRiderMode(value);
    
    if (context.mounted) {
      if (!success) {
        SnackbarUtils.showError(context, AppStrings.riderModeUpdateFailed);
        return;
      }

      isRiderMode = value;
      onStateUpdate();
      
      SnackbarUtils.showSuccess(
        context, 
        value ? AppStrings.riderModeEnabled : AppStrings.riderModeDisabled,
      );
      
      await loadRiderModeAndRides(onStateUpdate);
    }
  }

  Future<void> fetchRides(VoidCallback onStateUpdate) async {
    if (!isRiderMode) return;
    
    isLoading = true;
    onStateUpdate();
    
    try {
      final loadedRides = await ApiService.instance.getAvailableRides();
      rides = loadedRides;
    } catch (_) {
      // Ignore errors
    } finally {
      isLoading = false;
      onStateUpdate();
    }
  }

  Future<bool> sendCounterOffer(BuildContext context, String rideId, num amount) async {
    if (amount <= 0) {
      SnackbarUtils.showError(context, AppStrings.invalidOfferAmount);
      return false;
    }

    final success = await ApiService.instance.counterOfferRide(rideId, amount);
    
    if (context.mounted) {
      if (success) {
        SnackbarUtils.showSuccess(context, AppStrings.counterOfferSent);
      } else {
        SnackbarUtils.showError(context, AppStrings.counterOfferFailed);
      }
    }
    
    return success;
  }

  Future<void> acceptRide(BuildContext context, String rideId, VoidCallback onStateUpdate) async {
    final success = await ApiService.instance.acceptRide(rideId);
    
    if (context.mounted) {
      if (success) {
        SnackbarUtils.showSuccess(context, AppStrings.rideAccepted);
        fetchRides(onStateUpdate);
      } else {
        SnackbarUtils.showError(context, AppStrings.rideAcceptFailed);
      }
    }
  }
}
