class JobModel {
  final String id;
  final String title;
  final String description;
  final String budget;

  JobModel({
    required this.id,
    required this.title,
    required this.description,
    required this.budget,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? 'Untitled Job',
      description: json['description'] ?? 'No description provided',
      budget: json['budget']?.toString() ?? '0',
    );
  }
}
