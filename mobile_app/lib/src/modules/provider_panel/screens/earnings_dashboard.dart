import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';

class EarningsDashboardScreen extends StatelessWidget {
  const EarningsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Earnings')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Total Balance', style: AppTextStyles.bodySecondary),
            const SizedBox(height: 8),
            const Text('Rs. 24,500', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: AppColors.white)),
            const SizedBox(height: 24),
            
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Withdraw to Bank / JazzCash', style: TextStyle(color: AppColors.white)),
            ),
            
            const SizedBox(height: 48),
            const Text('Transaction History', style: AppTextStyles.h2),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildTxTile('Ride Payment', 'Rs. 850', 'Oct 28', isCredit: true),
                  _buildTxTile('Platform Fee (10%)', 'Rs. -85', 'Oct 28', isCredit: false),
                  _buildTxTile('Plumbing Job', 'Rs. 2500', 'Oct 27', isCredit: true),
                  _buildTxTile('Withdrawal', 'Rs. -5000', 'Oct 26', isCredit: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTxTile(String title, String amount, String date, {required bool isCredit}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: AppTextStyles.h3),
      subtitle: Text(date, style: AppTextStyles.bodySmall),
      trailing: Text(
        amount,
        style: TextStyle(
          color: isCredit ? AppColors.success : AppColors.danger,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
