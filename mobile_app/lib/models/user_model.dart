class UserModel {
  final String id;
  final String email;
  final String role;
  final Map<String, dynamic> profileData;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.profileData,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      email: json['email'],
      role: json['role'],
      profileData: json['profile_data'] ?? {},
    );
  }
}
