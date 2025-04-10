class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> images;
  final String category;
  final String subcategory;
  final int stockQuantity;
  final double rating;
  final Map<String, dynamic> attributes;
  final Map<String, List<String>> variants; 
  final String status;
  final bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.category,
    required this.subcategory,
    required this.stockQuantity,
    this.rating = 0.0,
    required this.attributes,
    this.variants = const {}, // Default to empty map
    required this.status,
    this.isFavorite = false,
  });

  // Create a copy of this product with some properties changed
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    List<String>? images,
    String? category,
    String? subcategory,
    int? stockQuantity,
    double? rating,
    Map<String, dynamic>? attributes,
    Map<String, List<String>>? variants,
    String? status,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      images: images ?? this.images,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      rating: rating ?? this.rating,
      attributes: attributes ?? this.attributes,
      variants: variants ?? this.variants,
      status: status ?? this.status,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  // Convert JSON to Product
  factory Product.fromJson(Map<String, dynamic> json) {
    // Handle images based on backend format
    List<String> imagesList = [];
    if (json['image_urls'] != null) {
      if (json['image_urls'] is List) {
        imagesList = List<String>.from(json['image_urls']);
      } else if (json['image_urls'] is Map) {
        // Handle if image_urls is provided as a JSON object
        imagesList = List<String>.from(json['image_urls'].values);
      }
    }

    // Handle variants
    Map<String, List<String>> variants = {};
    if (json['variants'] != null && json['variants'] is Map) {
      json['variants'].forEach((key, value) {
        if (value is List) {
          variants[key] = List<String>.from(value);
        } else if (value is String) {
          // If a single value is provided as a string
          variants[key] = [value];
        }
      });
    }

    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price:
          (json['price'] != null)
              ? double.tryParse(json['price'].toString()) ?? 0.0
              : 0.0,
      images: imagesList,
      category: json['categoryId'] ?? '',
      subcategory: json['subcategoryId'] ?? '',
      stockQuantity: json['stock_quantity'] ?? 0,
      rating:
          json['rating'] != null
              ? double.tryParse(json['rating'].toString()) ?? 0.0
              : 0.0,
      attributes: json['attributes'] ?? {},
      variants: variants,
      status: json['status'] ?? 'draft',
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  // Convert Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image_urls': images,
      'categoryId': category,
      'subcategoryId': subcategory,
      'stock_quantity': stockQuantity,
      'rating': rating,
      'attributes': attributes,
      'variants': variants,
      'status': status,
      'isFavorite': isFavorite,
    };
  }
}
