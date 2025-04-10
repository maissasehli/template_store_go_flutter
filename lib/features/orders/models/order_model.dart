class OrderModel {
  final String id;
  final String orderNumber;
  final int itemCount;
  final String status;
  final String date;
  final String shippingAddress;
  final String phoneNumber;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.itemCount,
    required this.status,
    required this.date,
    required this.shippingAddress,
    required this.phoneNumber,
  });
}