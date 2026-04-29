import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../common_widgets/app_button.dart';

class PaymentConfirmScreen extends StatelessWidget {
  final double amount;
  final String description;
  final VoidCallback? onConfirm;

  const PaymentConfirmScreen({
    super.key,
    this.amount = 0,
    this.description = '',
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final displayAmount = args?['amount'] ?? amount;
    final displayDesc = args?['description'] ?? description;

    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Payment')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.account_balance_wallet, size: 80, color: AppColors.primary),
            const SizedBox(height: 24),
            Text('Rs. $displayAmount',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(displayDesc.toString(), style: AppTextStyles.bodySecondary, textAlign: TextAlign.center),
            const Spacer(),
            AppButton(
              label: 'Pay Now',
              onPressed: onConfirm ?? () => Navigator.pop(context),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: AppColors.neutral400)),
            ),
          ],
        ),
      ),
    );
  }
}
