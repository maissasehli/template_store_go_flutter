class OrderRequest {
  final Address shippingAddress;
  final Address billingAddress;
  final String paymentMethod;
  final String? notes;

  OrderRequest({
    required this.shippingAddress,
    required this.billingAddress,
    required this.paymentMethod,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'shippingAddress': shippingAddress.toJson(),
    'billingAddress': billingAddress.toJson(),
    'paymentMethod': paymentMethod,
    if (notes != null && notes!.isNotEmpty) 'notes': notes,
  };
}

class Address {
  final String firstName;
  final String lastName;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String phone;

  Address({
    required this.firstName,
    required this.lastName,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'street': street,
    'city': city,
    'state': state,
    'zipCode': zipCode,
    'country': country,
    'phone': phone,
  };

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    firstName: json['firstName'] ?? '',
    lastName: json['lastName'] ?? '',
    street: json['street'] ?? '',
    city: json['city'] ?? '',
    state: json['state'] ?? '',
    zipCode: json['zipCode'] ?? '',
    country: json['country'] ?? '',
    phone: json['phone'] ?? '',
  );
}

class Order {
  final String id;
  final String orderNumber;
  final String status;
  final String paymentStatus;
  final double subtotal;
  final double tax;
  final double shippingCost;
  final double discount;
  final double totalAmount;
  final Address shippingAddress;
  final Address billingAddress;
  final String paymentMethod;
  final List<OrderItem> items;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.paymentStatus,
    required this.subtotal,
    required this.tax,
    required this.shippingCost,
    required this.discount,
    required this.totalAmount,
    required this.shippingAddress,
    required this.billingAddress,
    required this.paymentMethod,
    required this.items,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json['id'] ?? '',
    orderNumber: json['orderNumber'] ?? '',
    status: json['status'] ?? 'pending',
    paymentStatus: json['paymentStatus'] ?? 'pending',
    subtotal: (json['subtotal'] ?? 0.0).toDouble(),
    tax: (json['tax'] ?? 0.0).toDouble(),
    shippingCost: (json['shippingCost'] ?? 0.0).toDouble(),
    discount: (json['discount'] ?? 0.0).toDouble(),
    totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
    shippingAddress: Address.fromJson(json['shippingAddress'] ?? {}),
    billingAddress: Address.fromJson(json['billingAddress'] ?? {}),
    paymentMethod: json['paymentMethod'] ?? '',
    items:
        (json['items'] as List?)
            ?.map((item) => OrderItem.fromJson(item))
            .toList() ??
        [],
    createdAt: DateTime.parse(
      json['created_at'] ?? DateTime.now().toIso8601String(),
    ),
  );
}

class OrderItem {
  final String id;
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final Map<String, dynamic> variants;

  OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.variants,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    id: json['id'] ?? '',
    productId: json['productId'] ?? '',
    productName: json['productName'] ?? '',
    quantity: json['quantity'] ?? 0,
    unitPrice: (json['unitPrice'] ?? 0.0).toDouble(),
    totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
    variants: json['variants'] ?? {},
  );
}
