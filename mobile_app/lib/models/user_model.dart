// lib/models/user_model.dart
class UserModel {
  final String id;
  final String phone;
  final String? full_name;
  final List<String> roles;
  final String status;
  final String preferredLang;

  UserModel({
    required this.id,
    required this.phone,
    this.full_name,
    required this.roles,
    required this.status,
    required this.preferredLang,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      phone: json['phone'] ?? '',
      full_name: json['full_name'],
      roles: List<String>.from(json['roles'] ?? []),
      status: json['status'] ?? 'ACTIVE',
      preferredLang: json['preferred_lang'] ?? 'en',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'full_name': full_name,
      'roles': roles,
      'status': status,
      'preferred_lang': preferredLang,
    };
  }
}
