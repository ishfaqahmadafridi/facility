class TransactionModel {
  final String id;
  final double amount;
  final String transactionType;
  final String? description;
  final String status;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.transactionType,
    this.description,
    required this.status,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      transactionType: json['transaction_type'] ?? '',
      description: json['description'],
      status: json['status'] ?? 'COMPLETED',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
