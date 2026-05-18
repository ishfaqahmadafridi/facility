import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final bool processing;
  final VoidCallback onPressed;
  final String label;
  const SubmitButton({required this.processing, required this.onPressed, this.label = 'Pay & Hold in Escrow', super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            onPressed: processing ? null : onPressed,
            child: processing ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : Text(label, style: const TextStyle(fontSize: 18)),
          ),
        ),
      );
}
