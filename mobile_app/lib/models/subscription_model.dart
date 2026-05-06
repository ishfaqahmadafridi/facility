// lib/models/subscription_model.dart
class SubscriptionPlanModel {
  final String id;
  final String name;
  final String description;
  final String vertical;
  final double price;
  final int visitsPerMonth;
  final int durationDays;

  SubscriptionPlanModel({
    required this.id,
    required this.name,
    required this.description,
    required this.vertical,
    required this.price,
    required this.visitsPerMonth,
    required this.durationDays,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      vertical: json['vertical'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      visitsPerMonth: json['visits_per_month'] ?? 0,
      durationDays: json['duration_days'] ?? 30,
    );
  }
}

class UserSubscriptionModel {
  final String id;
  final String planId;
  final DateTime startDate;
  final DateTime endDate;
  final int visitsRemaining;
  final String status;

  UserSubscriptionModel({
    required this.id,
    required this.planId,
    required this.startDate,
    required this.endDate,
    required this.visitsRemaining,
    required this.status,
  });

  factory UserSubscriptionModel.fromJson(Map<String, dynamic> json) {
    return UserSubscriptionModel(
      id: json['id'] ?? '',
      planId: json['plan_id'] ?? '',
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      visitsRemaining: json['visits_remaining'] ?? 0,
      status: json['status'] ?? '',
    );
  }
}
