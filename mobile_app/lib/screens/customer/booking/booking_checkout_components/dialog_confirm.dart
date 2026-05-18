import 'package:flutter/material.dart';

class DialogConfirm {
  static AlertDialog bookingConfirmed(BuildContext context, VoidCallback onReturnHome) => AlertDialog(
        title: const Text('Booking Confirmed!'),
        content: const Text('Your payment has been held securely in Escrow. Work can now begin.'),
        actions: [TextButton(onPressed: onReturnHome, child: const Text('Return Home'))],
      );
}
