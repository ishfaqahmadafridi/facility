import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class ProviderEarningsView extends StatefulWidget {
  const ProviderEarningsView({super.key});

  @override
  State<ProviderEarningsView> createState() => _ProviderEarningsViewState();
}

class _ProviderEarningsViewState extends State<ProviderEarningsView> {
  Map<String, dynamic>? _walletData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWallet();
  }

  Future<void> _fetchWallet() async {
    setState(() => _isLoading = true);
    try {
      final data = await ApiService.instance.getWalletSummary();
      if (mounted) {
        setState(() {
          _walletData = data;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildSummaryCards() {
    final earnings = _walletData?['total_earnings'] ?? 0.0;
    final balance = _walletData?['current_balance'] ?? 0.0;
    final escrow = _walletData?['escrow_balance'] ?? 0.0;

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _StatCard(title: 'Active Balance', amount: balance, color: Colors.green)),
            const SizedBox(width: 12),
            Expanded(child: _StatCard(title: 'In Escrow (Pending)', amount: escrow, color: Colors.orange)),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: _StatCard(title: 'All-Time Earnings', amount: earnings, color: Colors.blue),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return RefreshIndicator(
      onRefresh: _fetchWallet,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('Earnings Dashboard', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _buildSummaryCards(),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Withdrawal Request Screen coming soon!')));
            },
            icon: const Icon(Icons.account_balance_wallet),
            label: const Text('Request Withdrawal (JazzCash / EasyPaisa)', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 40),
          const Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          
          if (_walletData?['recent_transactions'] == null || (_walletData?['recent_transactions'] as List).isEmpty)
             const Padding(
               padding: EdgeInsets.all(24.0),
               child: Center(child: Text('No historical transactions found.')),
             )
          else 
            ...(_walletData!['recent_transactions'] as List).map((tx) {
              final isEarning = tx['transaction_type'] == 'EARNING';
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: isEarning ? Colors.green.shade100 : Colors.red.shade100,
                  child: Icon(isEarning ? Icons.arrow_downward : Icons.arrow_upward, 
                    color: isEarning ? Colors.green : Colors.red),
                ),
                title: Text(tx['description'] ?? 'Transaction'),
                subtitle: Text(tx['timestamp']?.toString().split('T').first ?? ''),
                trailing: Text('${isEarning ? '+' : '-'} Rs ${tx['amount']}', 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isEarning ? Colors.green : Colors.red)),
              );
            }).toList(),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final double amount;
  final MaterialColor color;

  const _StatCard({required this.title, required this.amount, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: color.shade700, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 8),
          Text('Rs ${amount.toString().replaceAll('.0', '')}', style: TextStyle(color: color.shade900, fontWeight: FontWeight.bold, fontSize: 24)),
        ],
      ),
    );
  }
}
