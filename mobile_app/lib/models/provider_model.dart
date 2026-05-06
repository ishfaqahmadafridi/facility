// lib/models/provider_model.dart
class ProviderModel {
  final String userId;
  final String cnic;
  final String vertical;
  final bool isVerified;
  final String approvalStatus;
  final double rating;
  final int totalJobs;
  final bool isOnline;
  final List<String> skills;

  ProviderModel({
    required this.userId,
    required this.cnic,
    required this.vertical,
    required this.isVerified,
    required this.approvalStatus,
    required this.rating,
    required this.totalJobs,
    required this.isOnline,
    required this.skills,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      userId: json['user_id'] ?? '',
      cnic: json['cnic'] ?? '',
      vertical: json['vertical'] ?? '',
      isVerified: json['is_verified'] ?? false,
      approvalStatus: json['approval_status'] ?? 'PENDING',
      rating: (json['rating'] ?? 5.0).toDouble(),
      totalJobs: json['total_jobs'] ?? 0,
      isOnline: json['is_online'] ?? false,
      skills: List<String>.from(json['skills'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'cnic': cnic,
      'vertical': vertical,
      'is_verified': isVerified,
      'approval_status': approvalStatus,
      'rating': rating,
      'total_jobs': totalJobs,
      'is_online': isOnline,
      'skills': skills,
    };
  }
}
