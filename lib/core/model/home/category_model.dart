// lib/models/category_model.dart
class Category {
  final String id;
  final String name;
  final String? icon;
  final String? image;
  final int? productCount;  // Add this property

  Category({
    required this.id,
    required this.name,
    this.icon,
    this.image,
    this.productCount,  // Add this to the constructor
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String?,
      image: json['image'] as String?,
      productCount: json['productCount'] as int?,  // Parse from JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'image': image,
      'productCount': productCount,  // Add to JSON output
    };
  }
}