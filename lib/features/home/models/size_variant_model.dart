// lib/models/size_variant_model.dart
class SizeVariantModel {
  final String id;
  final String name;
  final bool isAvailable;
  final Map<String, dynamic>? additionalInfo;

  SizeVariantModel({
    required this.id,
    required this.name,
    this.isAvailable = true,
    this.additionalInfo,
  });

  factory SizeVariantModel.fromJson(Map<String, dynamic> json) {
    return SizeVariantModel(
      id: json['id'] as String,
      name: json['name'] as String,
      isAvailable: json['isAvailable'] as bool? ?? true,
      additionalInfo: json['additionalInfo'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isAvailable': isAvailable,
      'additionalInfo': additionalInfo,
    };
  }

  // Create a copy with updated values
  SizeVariantModel copyWith({
    String? id,
    String? name,
    bool? isAvailable,
    Map<String, dynamic>? additionalInfo,
  }) {
    return SizeVariantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isAvailable: isAvailable ?? this.isAvailable,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }
}