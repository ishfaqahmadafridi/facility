import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

/// Reusable dialog for sending a counter offer for a ride.
class CounterOfferDialog extends StatefulWidget {
  final num initialFare;
  final Future<bool> Function(num amount) onSubmit;

  const CounterOfferDialog({
    super.key,
    required this.initialFare,
    required this.onSubmit,
  });

  @override
  State<CounterOfferDialog> createState() => _CounterOfferDialogState();
}

class _CounterOfferDialogState extends State<CounterOfferDialog> {
  late final TextEditingController _bidController;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _bidController = TextEditingController(text: widget.initialFare.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _bidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Send Counter Offer'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Enter the fare you want to offer for this ride.'),
          const SizedBox(height: 16),
          TextField(
            controller: _bidController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              prefixText: 'Rs. ',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isProcessing ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.providerPrimary,
            foregroundColor: AppColors.textOnPrimary,
          ),
          onPressed: _isProcessing
              ? null
              : () async {
                  setState(() => _isProcessing = true);
                  final amount = num.tryParse(_bidController.text) ?? 0;
                  final success = await widget.onSubmit(amount);
                  
                  if (mounted && success) {
                    Navigator.pop(context, true);
                  } else if (mounted) {
                    setState(() => _isProcessing = false);
                  }
                },
          child: _isProcessing
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : const Text('Send Offer'),
        ),
      ],
    );
  }
}
