class Category {
  final String id;
  final String name;
  final String? imageUrl;
  final String? description;
  final String? userId;
  final String? storeId;
  final String? createdAt;
  final String? updatedAt;

  Category({
    required this.id,
    required this.name,
    this.imageUrl,
    this.description,
    this.userId,
    this.storeId,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to create a Category from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'].toString(),
      name: json['name'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      userId: json['userId']?.toString(),
      storeId: json['storeId']?.toString(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // Convert Category to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'userId': userId,
      'storeId': storeId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
