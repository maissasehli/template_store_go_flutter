class Category {
  late final String id;
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

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'].toString(),
      name: json['name'] ?? 'Unknown',
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
      'imageUrl': imageUrl,
      'description': description,
      'userId': userId,
      'storeId': storeId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}