import 'package:store_go/core/model/home/product_model.dart';

class CartItem {
  final String id;
  final Product product;
  final int quantity;
  final Map<String, String> variants;
  
  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.variants,
  });
  
  CartItem copyWith({
    String? id,
    Product? product,
    int? quantity,
    Map<String, String>? variants,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      variants: variants ?? this.variants,
    );
  }
  
  double get totalPrice => product.price * quantity;
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': product.id,
      'quantity': quantity,
      'variants': variants,
    };
  }
  
  factory CartItem.fromJson(Map<String, dynamic> json, Product product) {
    return CartItem(
      id: json['id'],
      product: product,
      quantity: json['quantity'],
      variants: Map<String, String>.from(json['variants']),
    );
  }
}