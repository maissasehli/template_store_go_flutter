class WishlistItemModel {
  final String id;
  final String storeId;
  final String appUserId;
  final String productId;
  final DateTime addedAt;
  final ProductModel product;

  WishlistItemModel({
    required this.id,
    required this.storeId,
    required this.appUserId,
    required this.productId,
    required this.addedAt,
    required this.product,
  });

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    return WishlistItemModel(
      id: json['id'] ?? '',
      storeId: json['storeId'] ?? '',
      appUserId: json['appUserId'] ?? '',
      productId: json['product_id'] ?? '',
      addedAt:
          json['added_at'] != null
              ? DateTime.parse(json['added_at'])
              : DateTime.now(),
      product:
          json['product'] != null
              ? ProductModel.fromJson(json['product'])
              : ProductModel.empty(),
    );
  }
}


class ProductModel {
  final String id;
  final String name;
  final String? description;
  final double price;
  final List<String> imageUrls;
  final int stockQuantity;

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.imageUrls,
    required this.stockQuantity,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      price: (json['price'] ?? 0).toDouble(),
      imageUrls: List<String>.from(json['image_urls'] ?? []),
      stockQuantity: json['stock_quantity'] ?? 0,
    );
  }

  factory ProductModel.empty() {
    return ProductModel(
      id: '',
      name: '',
      description: '',
      price: 0,
      imageUrls: [],
      stockQuantity: 0,
    );
  }
}
