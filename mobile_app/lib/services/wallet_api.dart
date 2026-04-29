import 'api_client.dart';
import '../models/wallet_model.dart';
import '../models/transaction_model.dart';

class WalletApi {
  final ApiClient _client = ApiClient();

  Future<WalletModel> getWallet() async {
    final response = await _client.get('/wallet');
    return WalletModel.fromJson(response.data);
  }

  Future<List<TransactionModel>> getTransactions() async {
    final response = await _client.get('/wallet/transactions');
    return (response.data as List).map((t) => TransactionModel.fromJson(t)).toList();
  }

  Future<TransactionModel> topUp(double amount, String paymentMethod) async {
    final response = await _client.post('/wallet/topup', data: {
      'amount': amount,
      'payment_method': paymentMethod,
    });
    return TransactionModel.fromJson(response.data);
  }
}
