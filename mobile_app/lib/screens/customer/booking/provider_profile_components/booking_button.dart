import 'package:flutter/material.dart';

class BookingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  const BookingButton({required this.onPressed, this.label = 'Book & Pay via Escrow', super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: onPressed,
            child: Text(label, style: const TextStyle(fontSize: 18)),
          ),
        ),
      );
}
