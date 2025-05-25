import 'package:store_go/features/cart/models/cart_model.dart';
import 'package:store_go/features/checkout/models/address_model.dart';

class OrderRequest {
  final Address shippingAddress;
  final Address billingAddress;
  final String paymentMethod;
  final List<CartItem> cartItems;
  final String? notes;

  OrderRequest({
    required this.shippingAddress,
    required this.billingAddress,
    required this.paymentMethod,
    required this.cartItems,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'shippingAddress': shippingAddress.toJson(),
    'billingAddress': billingAddress.toJson(),
    'paymentMethod': paymentMethod,
    'cartItems': cartItems.map((item) => item.toJson()).toList(),
    if (notes != null) 'notes': notes,
  };
}

class OrderResponse {
  final String orderId;
  final String orderNumber;
  final double totalAmount;
  final String status;
  final String paymentStatus;

  OrderResponse({
    required this.orderId,
    required this.orderNumber,
    required this.totalAmount,
    required this.status,
    required this.paymentStatus,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) => OrderResponse(
    orderId: json['orderId'] ?? '',
    orderNumber: json['orderNumber'] ?? '',
    totalAmount: double.parse((json['totalAmount'] ?? 0.0).toString()),
    status: json['status'] ?? 'pending',
    paymentStatus: json['paymentStatus'] ?? 'pending',
  );
}
