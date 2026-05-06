// lib/models/rating_model.dart
class RatingModel {
  final String id;
  final String reviewerId;
  final String revieweeId;
  final String referenceId;
  final String referenceType;
  final int score;
  final String? feedback;
  final DateTime createdAt;

  RatingModel({
    required this.id,
    required this.reviewerId,
    required this.revieweeId,
    required this.referenceId,
    required this.referenceType,
    required this.score,
    this.feedback,
    required this.createdAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'] ?? '',
      reviewerId: json['reviewer_id'] ?? '',
      revieweeId: json['reviewee_id'] ?? '',
      referenceId: json['reference_id'] ?? '',
      referenceType: json['reference_type'] ?? '',
      score: json['score'] ?? 0,
      feedback: json['feedback'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class AggregatedRatingModel {
  final String userId;
  final double averageScore;
  final int totalReviews;

  AggregatedRatingModel({
    required this.userId,
    required this.averageScore,
    required this.totalReviews,
  });

  factory AggregatedRatingModel.fromJson(Map<String, dynamic> json) {
    return AggregatedRatingModel(
      userId: json['user_id'] ?? '',
      averageScore: (json['average_score'] ?? 0).toDouble(),
      totalReviews: json['total_reviews'] ?? 0,
    );
  }
}
