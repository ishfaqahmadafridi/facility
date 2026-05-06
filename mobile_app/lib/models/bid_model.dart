// lib/models/bid_model.dart
class BidModel {
  final String id;
  final String driverId;
  final double bidAmount;
  final String status;

  BidModel({
    required this.id,
    required this.driverId,
    required this.bidAmount,
    required this.status,
  });

  factory BidModel.fromJson(Map<String, dynamic> json) {
    return BidModel(
      id: json['id'] ?? '',
      driverId: json['driver_id'] ?? '',
      bidAmount: (json['bid_amount'] ?? 0).toDouble(),
      status: json['status'] ?? 'PENDING',
    );
  }
}
