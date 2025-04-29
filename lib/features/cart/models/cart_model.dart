class CartItem {
  final String id;
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final String variantId; // Changed from Map<String, String> to String
  final String image;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.variantId,
    required this.image,
  });

  CartItem copyWith({
    String? id,
    String? productId,
    String? name,
    double? price,
    int? quantity,
    String? variantId,
    String? image,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      variantId: variantId ?? this.variantId,
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
      'variantId': variantId,
      'image': image,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final product = json['product'] ?? {};
    return CartItem(
      id: json['id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? json['productId']?.toString() ?? '',
      name: product['name']?.toString() ?? json['name']?.toString() ?? '',
      price: double.tryParse(product['price']?.toString() ?? '0.0') ?? 0.0,
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      variantId: json['variantId']?.toString() ?? '',
      image: (product['image_urls'] as List<dynamic>?)?.isNotEmpty == true
          ? product['image_urls'][0]?.toString() ?? ''
          : json['image']?.toString() ?? '',
    );
  }

  @override
  String toString() {
    return 'CartItem{id: $id, productId: $productId, name: $name, price: $price, quantity: $quantity, variantId: $variantId}';
  }
}