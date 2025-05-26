class UserModel {
  final String id;
  final String storeId;
  final String name;
  final String email;
  final String? avatar; // Changed back to avatar to match actual API response
  final String? gender;
  final String? ageRange;
  final String? phoneNumber; // Renamed from phone to match API
  final String? country;
  final String? dateOfBirth; // Added date_of_birth field (YYYY-MM-DD format)
  final bool status;
  final bool? isOnline; // Added for user status
  final DateTime? lastSeen; // Added for user status
  final DateTime createdAt;
  final DateTime updatedAt;
  UserModel({
    required this.id,
    required this.storeId,
    required this.name,
    required this.email,
    this.avatar, // Changed back to avatar
    this.gender,
    this.ageRange,
    this.phoneNumber, // Renamed from phone
    this.country,
    this.dateOfBirth, // Added date_of_birth
    required this.status,
    this.isOnline, // Added for user status
    this.lastSeen, // Added for user status
    required this.createdAt,
    required this.updatedAt,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      storeId: json['storeId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar:
          json['avatar']
              as String?, // Changed back to avatar to match API response
      gender: json['gender'] as String?,
      ageRange: json['age_range'] as String?,
      phoneNumber: json['phone_number'] as String?, // Updated field name
      country: json['country'] as String?,
      dateOfBirth: json['date_of_birth'] as String?, // Added new field
      status: json['status'] as bool,
      isOnline: json['is_online'] as bool?, // Added for user status
      lastSeen:
          json['last_seen'] != null
              ? DateTime.parse(json['last_seen'] as String)
              : null, // Added for user status
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
      'avatar': avatar, // Changed back to avatar
      'gender': gender,
      'age_range': ageRange,
      'phone_number': phoneNumber, // Updated field name
      'country': country,
      'date_of_birth': dateOfBirth, // Added new field
      'status': status,
      'is_online': isOnline, // Added for user status
      'last_seen': lastSeen?.toIso8601String(), // Added for user status
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
