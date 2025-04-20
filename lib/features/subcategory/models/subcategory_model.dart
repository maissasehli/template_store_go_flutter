class Subcategory {
  final String id;
  final String name;
  final String? parentCategoryId;
  final String? imageUrl;
  final String? description;
  final String? userId;
  final String? storeId;
  final String? createdAt;
  final String? updatedAt;

  Subcategory({
    required this.id,
    required this.name,
    this.parentCategoryId,
    this.imageUrl,
    this.description,
    this.userId,
    this.storeId,
    this.createdAt,
    this.updatedAt,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      id: json['id'].toString(),
      name: json['name'] ?? 'Unknown',
      parentCategoryId: json['parentCategoryId']?.toString(),
      imageUrl: (json['imageUrl'] == null || json['imageUrl'] == '' || json['imageUrl'] == 'none')
          ? null
          : json['imageUrl'],
      description: json['description'],
      userId: json['userId']?.toString(),
      storeId: json['storeId']?.toString(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'parentCategoryId': parentCategoryId,
      'imageUrl': imageUrl,
      'description': description,
      'userId': userId,
      'storeId': storeId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}