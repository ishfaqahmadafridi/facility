import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../../config/routes.dart';
import '../providers/wallet_provider.dart';
import '../widgets/transaction_tile.dart';

class WalletDashboardScreen extends StatefulWidget {
  const WalletDashboardScreen({super.key});

  @override
  State<WalletDashboardScreen> createState() => _WalletDashboardScreenState();
}

class _WalletDashboardScreenState extends State<WalletDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WalletProvider>().fetchWalletData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WalletProvider>();

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(title: const Text('My Wallet')),
      body: provider.isLoading && provider.wallet == null
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: provider.fetchWalletData,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  // Balance Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, Color(0xFF6C63FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Available Balance', style: TextStyle(color: Colors.white70)),
                        const SizedBox(height: 8),
                        Text(
                          'Rs. ${provider.wallet?.balance.toStringAsFixed(0) ?? '0'}',
                          style: AppTextStyles.h1.copyWith(color: AppColors.white),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => Navigator.pushNamed(context, AppRoutes.topUpScreen),
                                icon: const Icon(Icons.add, color: AppColors.primary),
                                label: const Text('Top Up', style: TextStyle(color: AppColors.primary)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  const Text('Recent Transactions', style: AppTextStyles.h2),
                  const SizedBox(height: 16),
                  
                  if (provider.transactions.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text('No transactions yet', style: AppTextStyles.bodySecondary),
                      ),
                    )
                  else
                    ...provider.transactions.map((tx) => TransactionTile(transaction: tx)),
                ],
              ),
            ),
    );
  }
}
