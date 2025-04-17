class CartItem {
  final String id;
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final Map<String, String> variants;
  final String image;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.variants,
    required this.image,
  });

  CartItem copyWith({
    String? id,
    String? productId,
    String? name,
    double? price,
    int? quantity,
    Map<String, String>? variants,
    String? image,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      variants: variants ?? this.variants,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'variants': variants,
      'image': image,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final product = json['product'] ?? {};
    return CartItem(
      id: json['id'] ?? '',
      productId: json['product_id'] ?? json['productId'] ?? '',
      name: product['name'] ?? json['name'] ?? '',
      price: double.tryParse(product['price']?.toString() ?? '0.0') ?? 0.0,
      quantity: json['quantity'] ?? 0,
      variants: Map<String, String>.from(json['variants'] ?? {}),
      image: (product['image_urls'] as List<dynamic>?)?.isNotEmpty == true
          ? product['image_urls'][0] ?? ''
          : json['image'] ?? '',
    );
  }

  @override
  String toString() {
    return 'CartItem{id: $id, productId: $productId, name: $name, price: $price, quantity: $quantity}';
  }
}