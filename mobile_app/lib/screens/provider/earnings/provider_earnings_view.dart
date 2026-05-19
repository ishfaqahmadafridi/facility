import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/snackbar_utils.dart';
import 'package:facility/services/api_service.dart';
import 'widgets/earnings_stat_card.dart';
import 'widgets/transaction_tile.dart';

/// Provider earnings dashboard — wallet summary + transactions.
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    final earnings = (_walletData?['total_earnings'] ?? 0.0) as double;
    final balance = (_walletData?['current_balance'] ?? 0.0) as double;
    final escrow = (_walletData?['escrow_balance'] ?? 0.0) as double;
    final transactions = (_walletData?['recent_transactions'] as List?) ?? [];

    return RefreshIndicator(
      onRefresh: _fetchWallet,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('Earnings Dashboard',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          // ── Summary Cards ──────────────────────────────────────────────
          Row(children: [
            Expanded(child: EarningsStatCard(
              title: 'Active Balance', amount: balance, color: AppColors.earningsActive)),
            const SizedBox(width: 12),
            Expanded(child: EarningsStatCard(
              title: 'In Escrow (Pending)', amount: escrow, color: AppColors.earningsEscrow)),
          ]),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: EarningsStatCard(
            title: 'All-Time Earnings', amount: earnings, color: AppColors.earningsAllTime)),
          const SizedBox(height: 30),

          // ── Withdraw Button ────────────────────────────────────────────
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.providerPrimary,
              foregroundColor: AppColors.textOnPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => SnackbarUtils.showInfo(
              context, AppStrings.withdrawalComingSoon),
            icon: const Icon(Icons.account_balance_wallet),
            label: const Text('Request Withdrawal (JazzCash / EasyPaisa)',
                style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 40),

          // ── Transactions ───────────────────────────────────────────────
          const Text('Recent Transactions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          if (transactions.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Center(child: Text('No historical transactions found.')),
            )
          else
            ...transactions.map((tx) => TransactionTile(
              transaction: (tx as Map).cast<String, dynamic>())),
        ],
      ),
    );
  }
}
