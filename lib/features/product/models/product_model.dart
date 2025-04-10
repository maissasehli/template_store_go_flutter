class ProductModels {
  String? id;
  String? name;
  String? description;
  String? price;
  String? discount;
  Attributes? attributes;
  String? imageUrls;
  int? stockQuantity;
  String? categoryId;
  String? createdAt;
  Variants? variants;
  bool? isFavorite;
  String? rating;
  int? reviewCount;
  String? subtitle; // Added missing subtitle property

  ProductModels({
    this.id,
    this.name,
    this.description,
    this.price,
    this.discount,
    this.attributes,
    this.imageUrls,
    this.stockQuantity,
    this.categoryId,
    this.createdAt,
    this.variants,
    this.isFavorite,
    this.rating,
    this.reviewCount,
    this.subtitle, // Added to constructor
  });

ProductModels.fromJson(Map<String, dynamic> json) {
  id = json['id'];
  name = json['name'];
  description = json['description'];
  price = json['price']?.toString();
  discount = json['discount']?.toString();
  attributes = json['attributes'] != null
      ? Attributes.fromJson(json['attributes'])
      : null;
  imageUrls = json['image_urls'] ?? json['imageUrls'];
  stockQuantity = json['stock_quantity'] ?? json['stockQuantity'];
  categoryId = json['categoryId'] ?? json['category_id'];
  createdAt = json['created_at'] ?? json['createdAt'];
  variants = json['variants'] != null ? Variants.fromJson(json['variants']) : null;
  isFavorite = json['is_favorite'] ?? json['isFavorite'] ?? false;
  rating = json['rating']?.toString();
  reviewCount = json['review_count'] ?? json['reviewCount'];
  subtitle = json['subtitle'] ?? ''; // Utiliser une chaîne vide si null
}

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['discount'] = discount;

    if (attributes != null) {
      data['attributes'] = attributes!.toJson();
    }

    data['image_urls'] = imageUrls;
    data['stock_quantity'] = stockQuantity;
    data['category_id'] = categoryId;
    data['created_at'] = createdAt;

    if (variants != null) {
      data['variants'] = variants!.toJson();
    }

    data['is_favorite'] = isFavorite;
    data['rating'] = rating;
    data['review_count'] = reviewCount;
    data['subtitle'] = subtitle; // Add subtitle to JSON

    return data;
  }
}

// Extension for ProductModels
extension ProductExtension on ProductModels {
  bool get isNew {
    if (createdAt == null || createdAt!.isEmpty) return false;
    
    try {
      final DateTime createdDate = DateTime.parse(createdAt!);
      final difference = DateTime.now().difference(createdDate);
      return difference.inDays <= 7; // Considered new for 7 days
    } catch (e) {
      print('Error parsing date: $e');
      return false;
    }
  }
  
  // Get final price after discount
  double get finalPrice {
    final double originalPrice = double.tryParse(price ?? '0.00') ?? 0.00;
    final double discountAmount = double.tryParse(discount ?? '0.00') ?? 0.00;
    
    return originalPrice > discountAmount ? originalPrice - discountAmount : originalPrice;
  }
  
  // Check if product has a discount
  bool get hasDiscount {
    if (discount == null || discount!.isEmpty) return false;
    
    final double discountAmount = double.tryParse(discount!) ?? 0.0;
    return discountAmount > 0;
  }
  
  // Add inStock getter
  bool get inStock => stockQuantity != null && stockQuantity! > 0;

}

// Rest of the classes remain unchanged
class Attributes {
  List<String>? size;
  List<String>? color;

  Attributes({this.size, this.color});

  Attributes.fromJson(Map<String, dynamic> json) {
    size = json['size']?.cast<String>();
    color = json['color']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['size'] = size;
    data['color'] = color;
    return data;
  }
}

class Variants {
  Variants();

  Variants.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() => {};
}

extension ProductModelsCopyWith on ProductModels {
  ProductModels copyWith({
    String? id,
    String? name,
    String? description,
    String? price,
    String? discount,
    Attributes? attributes,
    String? imageUrls,
    int? stockQuantity,
    String? categoryId,
    String? createdAt,
    Variants? variants,
    bool? isFavorite,
    String? rating,
    int? reviewCount,
    String? subtitle, // Add to copyWith
  }) {
    return ProductModels(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      attributes: attributes ?? this.attributes,
      imageUrls: imageUrls ?? this.imageUrls,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
      variants: variants ?? this.variants,
      isFavorite: isFavorite ?? this.isFavorite,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      subtitle: subtitle ?? this.subtitle,
    );
  }
}