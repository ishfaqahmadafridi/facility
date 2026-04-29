import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../../models/transaction_model.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isTopUp = transaction.transactionType == 'TOP_UP' || transaction.transactionType == 'PAYMENT_RECEIVED';
    final amountColor = isTopUp ? AppColors.success : AppColors.textPrimary;
    final sign = isTopUp ? '+' : '-';

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: AppColors.bgCard,
        child: Icon(
          isTopUp ? Icons.arrow_downward : Icons.arrow_upward,
          color: amountColor,
        ),
      ),
      title: Text(transaction.transactionType.replaceAll('_', ' '), style: AppTextStyles.h3),
      subtitle: Text(
        "${transaction.createdAt.day}/${transaction.createdAt.month}/${transaction.createdAt.year}",
        style: AppTextStyles.bodySmall,
      ),
      trailing: Text(
        "$sign Rs. ${transaction.amount.toStringAsFixed(0)}",
        style: TextStyle(color: amountColor, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
