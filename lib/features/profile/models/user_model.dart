class UserModel {
  final String id;
  final String storeId;
  final String name;
  final String email;
  final String? avatar;
  final String? gender;
  final String? ageRange;
  final bool status;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.storeId,
    required this.name,
    required this.email,
    this.avatar,
    this.gender,
    this.ageRange,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      storeId: json['storeId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String?,
      gender: json['gender'] as String?,
      ageRange: json['age_range'] as String?,
      status: json['status'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storeId': storeId,
      'name': name,
      'email': email,
      'avatar': avatar,
      'gender': gender,
      'age_range': ageRange,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}