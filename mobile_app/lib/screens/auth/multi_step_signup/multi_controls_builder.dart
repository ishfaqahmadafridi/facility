import 'package:flutter/material.dart';

class MultiControlsBuilder extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback? onContinue;
  final VoidCallback? onCancel;

  const MultiControlsBuilder({required this.currentStep, required this.totalSteps, this.onContinue, this.onCancel, super.key});

  @override
  Widget build(BuildContext context) {
    final isLastStep = currentStep == totalSteps - 1;
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onContinue,
              child: Text(isLastStep ? 'Submit' : 'Next'),
            ),
          ),
          const SizedBox(width: 10),
          if (currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: onCancel,
                child: const Text('Back'),
              ),
            ),
        ],
      ),
    );
  }
}
