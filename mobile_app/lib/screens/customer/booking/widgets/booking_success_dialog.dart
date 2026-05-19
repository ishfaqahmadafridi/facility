import 'package:flutter/material.dart';

/// Dialog shown when a booking is successfully created.
class BookingSuccessDialog extends StatelessWidget {
  const BookingSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Booking Confirmed!'),
      content: const Text('Your payment has been held securely in Escrow. Work can now begin.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // close dialog
            Navigator.pop(context); // close checkout
            Navigator.pop(context); // close profile -> return to dashboard
          },
          child: const Text('Return Home'),
        )
      ],
    );
  }
}
