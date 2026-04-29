import 'package:flutter/material.dart';
import '../../../../models/wallet_model.dart';
import '../../../../models/transaction_model.dart';
import '../../../../services/wallet_api.dart';

class WalletProvider extends ChangeNotifier {
  final WalletApi _walletApi = WalletApi();

  WalletModel? _wallet;
  WalletModel? get wallet => _wallet;

  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchWalletData() async {
    _isLoading = true;
    notifyListeners();
    try {
      _wallet = await _walletApi.getWallet();
      _transactions = await _walletApi.getTransactions();
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> topUp(double amount, String method) async {
    try {
      await _walletApi.topUp(amount, method);
      await fetchWalletData(); // Refresh data
      return true;
    } catch (e) {
      return false;
    }
  }
}
