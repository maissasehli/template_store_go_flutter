// lib/features/wishlist/model/wishlist_item_model.dart
class WishlistItem {
  final String id;
  final String productId; // Add this field to store the reference to the product
  final String name;
  final String description;
  final double price;
  final int quantity;
  
  WishlistItem({
    required this.id,
    this.productId = '', // Initialize with empty string
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
  });
  
  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'] ?? '',
      productId: json['product_id'] ?? json['productId'] ?? '',
      name: json['name'] ?? 'Unknown Product',
      description: json['description'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      quantity: json['quantity'] ?? 1,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'name': name,
      'description': description,
      'price': price.toString(),
      'quantity': quantity,
    };
  }
  
  WishlistItem copyWith({
    String? id,
    String? productId,
    String? name,
    String? description,
    double? price,
    int? quantity,
  }) {
    return WishlistItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}