import 'dart:developer' as developer;

import 'package:store_go/features/review/model/review_model.dart';

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
  final List<Map<String, String>> colors;
  final String status;
  final bool isFavorite;
  final List<Review> reviews;
  final DateTime createdAt; // New: For "New Today" sorting
  final int? salesCount; // New: For "Top Sellers" sorting

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
    this.variants = const {},
    this.colors = const [],
    required this.status,
    this.isFavorite = false,
    this.reviews = const [],
    required this.createdAt,
    this.salesCount,
  });

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
    List<Map<String, String>>? colors,
    String? status,
    bool? isFavorite,
    List<Review>? reviews,
    DateTime? createdAt,
    int? salesCount,
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
      colors: colors ?? this.colors,
      status: status ?? this.status,
      isFavorite: isFavorite ?? this.isFavorite,
      reviews: reviews ?? this.reviews,
      createdAt: createdAt ?? this.createdAt,
      salesCount: salesCount ?? this.salesCount,
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    developer.log('Parsing Product JSON: $json', name: 'Product.fromJson');

    String extractString(dynamic value, String fieldName) {
      try {
        if (value is String) {
          return value;
        } else if (value is Map<String, dynamic>) {
          final extracted = value['id']?.toString() ?? '';
          developer.log('$fieldName is an object, extracted id: $extracted', name: 'Product.fromJson');
          return extracted;
        } else {
          developer.log('Unexpected $fieldName format: $value', name: 'Product.fromJson');
          return '';
        }
      } catch (e) {
        developer.log('Error parsing $fieldName: $e', name: 'Product.fromJson', error: e);
        return '';
      }
    }

    final categoryId = extractString(json['categoryId'], 'categoryId');
    final subcategoryId = extractString(json['subcategoryId'], 'subcategoryId');

    List<String> imagesList = [];
    try {
      if (json['image_urls'] != null) {
        if (json['image_urls'] is List) {
          imagesList = List<String>.from(json['image_urls'].map((e) => e.toString()));
        } else if (json['image_urls'] is Map) {
          imagesList = List<String>.from(json['image_urls'].values.map((e) => e.toString()));
        }
      }
    } catch (e) {
      developer.log('Error parsing image_urls: $e', name: 'Product.fromJson', error: e);
    }

    Map<String, List<String>> variants = {};
    List<Map<String, String>> colorsList = [];
    try {
      if (json['colors'] != null && json['colors'] is List) {
        colorsList = (json['colors'] as List<dynamic>).map((color) {
          if (color is Map<String, dynamic>) {
            return {
              'value': color['value']?.toString() ?? '',
              'customColor': color['customColor']?.toString() ?? '',
              'colorClass': color['colorClass']?.toString() ?? '',
            };
          }
          return {'value': color.toString(), 'customColor': '', 'colorClass': ''};
        }).toList();
        variants['color'] = colorsList.map((color) => color['value']!).toList();
      }
      if (json['size'] != null && json['size'] is List) {
        variants['size'] = List<String>.from(json['size'].map((e) => e.toString()));
      }
    } catch (e) {
      developer.log('Error parsing variants: $e', name: 'Product.fromJson', error: e);
    }

    List<Review> reviewsList = [];
    try {
      if (json['reviews'] != null && json['reviews'] is List) {
        reviewsList = (json['reviews'] as List)
            .map((reviewJson) => Review.fromJson(reviewJson as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      developer.log('Error parsing reviews: $e', name: 'Product.fromJson', error: e);
    }

    Map<String, dynamic> attributes = {};
    try {
      if (json['attributes'] is Map) {
        attributes = Map<String, dynamic>.from(json['attributes']);
      }
    } catch (e) {
      developer.log('Error parsing attributes: $e', name: 'Product.fromJson', error: e);
    }

    try {
      return Product(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        price: double.tryParse(json['price']?.toString() ?? '0.0') ?? 0.0,
        images: imagesList,
        category: categoryId,
        subcategory: subcategoryId,
        stockQuantity: int.tryParse(json['stock_quantity']?.toString() ?? '0') ?? 0,
        rating: double.tryParse(json['rating']?.toString() ?? '0.0') ?? 0.0,
        attributes: attributes,
        variants: variants,
        colors: colorsList,
        status: json['status']?.toString() ?? 'draft',
        isFavorite: json['isFavorite'] as bool? ?? false,
        reviews: reviewsList,
        createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
        salesCount: int.tryParse(json['sales_count']?.toString() ?? ''),
      );
    } catch (e) {
      developer.log('Error constructing Product: $e', name: 'Product.fromJson', error: e);
      rethrow;
    }
  }

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
      'colors': colors,
      'size': variants['size'] ?? [],
      'status': status,
      'isFavorite': isFavorite,
      'reviews': reviews.map((review) => review.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'sales_count': salesCount,
    };
  }
}