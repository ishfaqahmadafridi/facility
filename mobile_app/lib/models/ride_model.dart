// lib/models/ride_model.dart
import 'bid_model.dart';

class RideModel {
  final String id;
  final String customerId;
  final String? driverId;
  final String status;
  final String rideType;
  final double distanceKm;
  final double estimatedPrice;
  final double? finalPrice;
  final String pickupAddress;
  final String dropoffAddress;
  final List<BidModel> bids;

  RideModel({
    required this.id,
    required this.customerId,
    this.driverId,
    required this.status,
    required this.rideType,
    required this.distanceKm,
    required this.estimatedPrice,
    this.finalPrice,
    required this.pickupAddress,
    required this.dropoffAddress,
    this.bids = const [],
  });

  factory RideModel.fromJson(Map<String, dynamic> json) {
    return RideModel(
      id: json['id'] ?? '',
      customerId: json['customer_id'] ?? '',
      driverId: json['driver_id'],
      status: json['status'] ?? 'REQUESTED',
      rideType: json['ride_type'] ?? 'STANDARD',
      distanceKm: (json['distance_km'] ?? 0).toDouble(),
      estimatedPrice: (json['estimated_price'] ?? 0).toDouble(),
      finalPrice: json['final_price'] != null ? (json['final_price']).toDouble() : null,
      pickupAddress: json['pickup_address'] ?? '',
      dropoffAddress: json['dropoff_address'] ?? '',
      bids: (json['bids'] as List?)?.map((b) => BidModel.fromJson(b)).toList() ?? [],
    );
  }
}
