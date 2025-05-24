class CartItem {
  final String id;
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final String? selectedColor;
  final String? selectedSize;
  final Map<String, String>? variants;
  final String image;
  final String? category; // Add category field

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    this.selectedColor,
    this.selectedSize,
    this.variants,
    required this.image,
    this.category, // Add to constructor
  });

  CartItem copyWith({
    String? id,
    String? productId,
    String? name,
    double? price,
    int? quantity,
    String? selectedColor,
    String? selectedSize,
    Map<String, String>? variants,
    String? image,
    String? category, // Add category to copyWith
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedSize: selectedSize ?? this.selectedSize,
      variants: variants ?? this.variants,
      image: image ?? this.image,
      category: category ?? this.category, // Handle category in copyWith
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'selectedColor': selectedColor,
      'selectedSize': selectedSize,
      'variants': variants,
      'image': image,
      'category': category, // Include category in toJson
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final product = json['product'] ?? {};

    // Parse variants from both old format and new format
    Map<String, String>? variants;
    final variantsData = json['variants'];
    if (variantsData is Map<String, dynamic>) {
      variants = variantsData.map(
        (key, value) => MapEntry(key, value.toString()),
      );
    }

    // Extract image with multiple fallback options
    String imageUrl = '';

    // Try different possible image sources
    if (product['image_urls'] is List &&
        (product['image_urls'] as List).isNotEmpty) {
      imageUrl = product['image_urls'][0]?.toString() ?? '';
    } else if (product['imageUrls'] is List &&
        (product['imageUrls'] as List).isNotEmpty) {
      imageUrl = product['imageUrls'][0]?.toString() ?? '';
    } else if (product['images'] is List &&
        (product['images'] as List).isNotEmpty) {
      imageUrl = product['images'][0]?.toString() ?? '';
    } else if (product['image'] != null) {
      imageUrl = product['image']?.toString() ?? '';
    } else if (json['image'] != null) {
      imageUrl = json['image']?.toString() ?? '';
    }

    // Extract category from product data
    String? categoryName;
    final categoryData = product['category'];
    if (categoryData is Map<String, dynamic>) {
      categoryName = categoryData['name']?.toString();
    } else if (categoryData is String) {
      categoryName = categoryData;
    }

    return CartItem(
      id: json['id']?.toString() ?? '',
      productId:
          json['product_id']?.toString() ?? json['productId']?.toString() ?? '',
      name: product['name']?.toString() ?? json['name']?.toString() ?? '',
      price: double.tryParse(product['price']?.toString() ?? '0.0') ?? 0.0,
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      selectedColor: json['selectedColor']?.toString() ?? variants?['color'],
      selectedSize: json['selectedSize']?.toString() ?? variants?['size'],
      variants: variants,
      image: imageUrl,
      category: categoryName,
    );
  }

  // Helper getter for backward compatibility
  String get variantId {
    if (variants == null || variants!.isEmpty) return '';
    final sortedEntries =
        variants!.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    return sortedEntries
        .map((entry) => '${entry.key}:${entry.value}')
        .join('|');
  }

  @override
  String toString() {
    return 'CartItem{id: $id, productId: $productId, name: $name, price: $price, quantity: $quantity, selectedColor: $selectedColor, selectedSize: $selectedSize, variants: $variants, category: $category}';
  }
}
