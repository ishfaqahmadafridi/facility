import 'package:flutter/material.dart';

/// A single row in the transactions list.
class TransactionTile extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isEarning = transaction['transaction_type'] == 'EARNING';

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isEarning ? Colors.green.shade100 : Colors.red.shade100,
        child: Icon(
          isEarning ? Icons.arrow_downward : Icons.arrow_upward,
          color: isEarning ? Colors.green : Colors.red,
        ),
      ),
      title: Text(transaction['description'] ?? 'Transaction'),
      subtitle: Text(
        transaction['timestamp']?.toString().split('T').first ?? '',
      ),
      trailing: Text(
        '${isEarning ? '+' : '-'} Rs ${transaction['amount']}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: isEarning ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
