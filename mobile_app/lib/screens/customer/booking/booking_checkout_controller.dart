import 'package:flutter/material.dart';
import 'package:facility/services/api_service.dart';

import 'widgets/booking_success_dialog.dart';

/// Controller handling the business logic for creating a job booking.
class BookingCheckoutController {
  final Map<String, dynamic> providerDetails;
  
  bool isProcessing = false;

  BookingCheckoutController({required this.providerDetails});

  Future<void> processBooking(
    BuildContext context, 
    String amount, 
    String description, 
    VoidCallback onStateUpdate
  ) async {
    if (amount.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    isProcessing = true;
    onStateUpdate();
    
    final providerUserId = providerDetails['user']?['id'];
    
    final jobData = {
      'provider_id': providerUserId,
      'category': (providerDetails['categories'] as List?)?.isNotEmpty == true 
          ? providerDetails['categories'][0] 
          : 'General',
      'price': amount,
      'description': description,
      // Map pinning coordinates placeholder
      'latitude': 33.6844, 
      'longitude': 73.0479,
    };

    final success = await ApiService.instance.createJobBooking(jobData);
    
    isProcessing = false;
    onStateUpdate();
    
    if (context.mounted) {
      if (success) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const BookingSuccessDialog(),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create booking')),
        );
      }
    }
  }
}
