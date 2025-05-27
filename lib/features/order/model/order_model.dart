import 'package:store_go/app/core/localization/translation_extension.dart';

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
    'postalCode': zipCode, // Map zipCode to postalCode for API
    'country': country,
    'phone': phone,
  };
  factory Address.fromJson(Map<String, dynamic> json) => Address(
    firstName: json['firstName'] ?? '',
    lastName: json['lastName'] ?? '',
    street: json['street'] ?? '',
    city: json['city'] ?? '',
    state: json['state'] ?? '',
    zipCode: json['zipCode'] ?? json['postalCode'] ?? '',
    country: json['country'] ?? '',
    phone: json['phone'] ?? '',
  );
}

class OrderModel {
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
  final List<OrderItemModel> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderModel({
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
    required this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
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
            ?.map((item) => OrderItemModel.fromJson(item))
            .toList() ??
        [],
    createdAt: DateTime.parse(
      json['created_at'] ?? DateTime.now().toIso8601String(),
    ),
    updatedAt: DateTime.parse(
      json['updated_at'] ?? DateTime.now().toIso8601String(),
    ),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'orderNumber': orderNumber,
    'status': status,
    'paymentStatus': paymentStatus,
    'subtotal': subtotal,
    'tax': tax,
    'shippingCost': shippingCost,
    'discount': discount,
    'totalAmount': totalAmount,
    'shippingAddress': shippingAddress.toJson(),
    'billingAddress': billingAddress.toJson(),
    'paymentMethod': paymentMethod,
    'items': items.map((item) => item.toJson()).toList(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  // Getter for formatted address
  String get formattedShippingAddress =>
      '${shippingAddress.street}, ${shippingAddress.city}, ${shippingAddress.state} ${shippingAddress.zipCode}';
  // Getter for formatted date
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays == 0) {
      return 'date_format.today'.translate();
    } else if (difference.inDays == 1) {
      return 'date_format.yesterday'.translate();
    } else if (difference.inDays < 7) {
      return 'date_format.days_ago'.translateWithParam({
        'count': difference.inDays.toString(),
      });
    } else {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }

  // Getter for order status color
  String get statusColor {
    switch (status.toLowerCase()) {
      case 'pending':
        return '#FFA500';
      case 'processing':
        return '#007BFF';
      case 'shipped':
        return '#28A745';
      case 'delivered':
        return '#28A745';
      case 'cancelled':
        return '#DC3545';
      default:
        return '#6C757D';
    }
  }

  // Getter for item count
  int get itemCount => items.fold(0, (total, item) => total + item.quantity);
}

class OrderItemModel {
  final String id;
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final Map<String, dynamic> variants;
  final ProductInfo? product;

  OrderItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.variants,
    this.product,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => OrderItemModel(
    id: json['id'] ?? '',
    productId: json['productId'] ?? '',
    productName: json['productName'] ?? '',
    quantity: json['quantity'] ?? 0,
    unitPrice: (json['unitPrice'] ?? 0.0).toDouble(),
    totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
    variants: json['variants'] ?? {},
    product:
        json['product'] != null ? ProductInfo.fromJson(json['product']) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'productId': productId,
    'productName': productName,
    'quantity': quantity,
    'unitPrice': unitPrice,
    'totalPrice': totalPrice,
    'variants': variants,
    if (product != null) 'product': product!.toJson(),
  };
}

class ProductInfo {
  final String id;
  final String name;
  final double price;
  final List<String> imageUrls;

  ProductInfo({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrls,
  });

  factory ProductInfo.fromJson(Map<String, dynamic> json) => ProductInfo(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    price: (json['price'] ?? 0.0).toDouble(),
    imageUrls: List<String>.from(json['imageUrls'] ?? json['image_urls'] ?? []),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'imageUrls': imageUrls,
  };
}
