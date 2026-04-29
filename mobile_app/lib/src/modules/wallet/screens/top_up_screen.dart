import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../common_widgets/app_button.dart';
import '../../../common_widgets/app_text_field.dart';
import '../providers/wallet_provider.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({super.key});

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  final _amountController = TextEditingController();
  String _selectedMethod = 'EASYPAISA';

  void _submitTopUp() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) return;

    final provider = context.read<WalletProvider>();
    final success = await provider.topUp(amount, _selectedMethod);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Top up successful!')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Up Wallet')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              label: 'Amount (Rs)',
              controller: _amountController,
              keyboardType: TextInputType.number,
              hint: '1000',
            ),
            const SizedBox(height: 24),
            const Text('Payment Method', style: AppTextStyles.h3),
            const SizedBox(height: 16),
            
            _buildMethodSelector('EASYPAISA', 'Easypaisa'),
            _buildMethodSelector('JAZZCASH', 'JazzCash'),
            _buildMethodSelector('CARD', 'Credit/Debit Card'),
            
            const Spacer(),
            AppButton(
              label: 'Confirm Top Up',
              onPressed: _submitTopUp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodSelector(String value, String label) {
    final isSelected = _selectedMethod == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.neutral700),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.primary : AppColors.neutral400,
            ),
            const SizedBox(width: 16),
            Text(label, style: AppTextStyles.body),
          ],
        ),
      ),
    );
  }
}
