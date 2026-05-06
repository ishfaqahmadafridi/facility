class WalletModel {
  final String id;
  final String userId;
  final double balance;
  final String currency;

  WalletModel({
    required this.id,
    required this.userId,
    required this.balance,
    required this.currency,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'PKR',
    );
  }
}
