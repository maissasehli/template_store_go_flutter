// lib/models/product_model.dart
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> images;
  final String category;
  final Map<String, List<String>> variants; // ex: {"size": ["S", "M", "L"], "color": ["red", "blue"]}
  final double rating;
  final int reviewCount;
  final bool isFavorite;
  final bool isInStock;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.category,
    required this.variants,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isFavorite = false,
    this.isInStock = true,
  });

  // From JSON factory
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      images: List<String>.from(json['images'] as List),
      category: json['category'] as String,
      variants: Map<String, List<String>>.from(
        (json['variants'] as Map).map((key, value) => 
          MapEntry(key as String, List<String>.from(value as List))
        ),
      ),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      isFavorite: json['isFavorite'] as bool? ?? false,
      isInStock: json['isInStock'] as bool? ?? true,
    );
  }

  // To JSON method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'images': images,
      'category': category,
      'variants': variants,
      'rating': rating,
      'reviewCount': reviewCount,
      'isFavorite': isFavorite,
      'isInStock': isInStock,
    };
  }

  // Copy with method to create a new instance with some properties changed
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    List<String>? images,
    String? category,
    Map<String, List<String>>? variants,
    double? rating,
    int? reviewCount,
    bool? isFavorite,
    bool? isInStock,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      images: images ?? this.images,
      category: category ?? this.category,
      variants: variants ?? this.variants,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isFavorite: isFavorite ?? this.isFavorite,
      isInStock: isInStock ?? this.isInStock,
    );
  }
}