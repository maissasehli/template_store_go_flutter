import 'package:store_go/features/wishlist/models/wishlist_item_model.dart';

class OrderModel {
  final String id;
  final String orderNumber;
  final int itemCount;
  final String status;
  final DateTime date;
  final String shippingAddress;
  final String phoneNumber;
  final List<OrderItemModel> items;
  final double totalAmount;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.itemCount,
    required this.status,
    required this.date,
    required this.shippingAddress,
    required this.phoneNumber,
    required this.items,
    required this.totalAmount,
  });

factory OrderModel.fromJson(Map<String, dynamic> json) {
  List<OrderItemModel> orderItems = [];
  if (json['items'] != null) {
    orderItems = (json['items'] as List)
        .map((item) => OrderItemModel.fromJson(item))
        .toList();
  }

return OrderModel(
    id: json['id'] ?? '',              
    orderNumber: json['order_number'] ?? '',
      itemCount: json['item_count'] ?? orderItems.length,
      status: json['status'] ?? 'Processing',
      date: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      shippingAddress: json['shipping_address'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      items: orderItems,
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
    );
  }

  // Helper method to get formatted date string
  String get formattedDate {
    return '${date.day} ${_getMonthName(date.month)}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}

class OrderItemModel {
  final String id;
  final String orderId;
  final String productId;
  final int quantity;
  final double price;
  final ProductModel product;

  OrderItemModel({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.product,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] ?? '',
      orderId: json['order_id'] ?? '',
      productId: json['product_id'] ?? '',
      quantity: json['quantity'] ?? 1,
      price: (json['price'] ?? 0).toDouble(),
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : ProductModel.empty(),
    );
  }
}