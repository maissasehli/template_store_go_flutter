// lib/models/color_variant_model.dart
class ColorVariantModel {
  final String id;
  final String name;
  final String hexCode;
  final bool isAvailable;
  final Map<String, dynamic>? additionalInfo;

  ColorVariantModel({
    required this.id,
    required this.name,
    required this.hexCode,
    this.isAvailable = true,
    this.additionalInfo,
  });

  factory ColorVariantModel.fromJson(Map<String, dynamic> json) {
    return ColorVariantModel(
      id: json['id'] as String,
      name: json['name'] as String,
      hexCode: json['hexCode'] as String,
      isAvailable: json['isAvailable'] as bool? ?? true,
      additionalInfo: json['additionalInfo'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'hexCode': hexCode,
      'isAvailable': isAvailable,
      'additionalInfo': additionalInfo,
    };
  }

  // Create a copy with updated values
  ColorVariantModel copyWith({
    String? id,
    String? name,
    String? hexCode,
    bool? isAvailable,
    Map<String, dynamic>? additionalInfo,
  }) {
    return ColorVariantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      hexCode: hexCode ?? this.hexCode,
      isAvailable: isAvailable ?? this.isAvailable,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }
}