// lib/models/booking_model.dart
class BookingModel {
  final String id;
  final String customerId;
  final String? providerId;
  final String vertical;
  final String serviceType;
  final String status;
  final String address;
  final double price;
  final String? notes;
  final DateTime? scheduledFor;

  BookingModel({
    required this.id,
    required this.customerId,
    this.providerId,
    required this.vertical,
    required this.serviceType,
    required this.status,
    required this.address,
    required this.price,
    this.notes,
    this.scheduledFor,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? '',
      customerId: json['customer_id'] ?? '',
      providerId: json['provider_id'],
      vertical: json['vertical'] ?? '',
      serviceType: json['service_type'] ?? '',
      status: json['status'] ?? 'SEARCHING',
      address: json['address'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      notes: json['notes'],
      scheduledFor: json['scheduled_for'] != null 
          ? DateTime.parse(json['scheduled_for']) 
          : null,
    );
  }
}
