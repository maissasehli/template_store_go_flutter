# StoreGo API Reference for Flutter Apps

This document provides a complete API reference for Flutter developers integrating with the StoreGo platform.

## Base Configuration

```dart
class ApiConfig {
  static const String baseUrl = 'https://store-go.vercel.app';
  static const String apiVersion = 'v1';

  // Headers for all requests
  static Map<String, String> getHeaders(String? token) => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };
}
```

## Authentication Endpoints

### Sign In

```dart
POST /api/mobile-app/auth/sign-in

// Request
{
  "storeId": "uuid",
  "email": "string",
  "password": "string"
}

// Response (200)
{
  "success": true,
  "message": "User authenticated successfully",
  "session": {
    "accessToken": "jwt_token",
    "refreshToken": "refresh_token",
    "userId": "uuid",
    "expiresAt": "2025-05-13T11:10:12.000Z"
  }
}

// Flutter Implementation
Future<AuthResult> signIn(String email, String password) async {
  final response = await http.post(
    Uri.parse('${ApiConfig.baseUrl}/api/mobile-app/auth/sign-in'),
    headers: ApiConfig.getHeaders(null),
    body: jsonEncode({
      'storeId': AppConfig.storeId,
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return AuthResult.fromJson(data);
  }
  throw ApiException.fromResponse(response);
}
```

### Sign Up

```dart
POST /api/mobile-app/auth/sign-up

// Request
{
  "storeId": "uuid",
  "name": "string",
  "email": "string",
  "password": "string"
}

// Response (201)
{
  "success": true,
  "message": "User registered successfully",
  "session": {
    "accessToken": "jwt_token",
    "refreshToken": "refresh_token",
    "userId": "uuid",
    "expiresAt": "2025-05-13T11:10:12.000Z"
  }
}
```

### Refresh Token

```dart
POST /api/mobile-app/auth/refresh

// Request
{
  "refreshToken": "string"
}

// Response (200)
{
  "success": true,
  "session": {
    "accessToken": "new_jwt_token",
    "refreshToken": "new_refresh_token",
    "userId": "uuid",
    "expiresAt": "2025-05-13T13:10:12.000Z"
  }
}
```

## Product Endpoints

### Get All Products

```dart
GET /api/mobile-app/products
Authorization: Bearer {token}

// Response (200)
{
  "status": "success",
  "data": [
    {
      "id": "uuid",
      "name": "string",
      "description": "string",
      "price": "decimal",
      "image_urls": ["string"],
      "stock_quantity": 10,
      "colors": ["red", "blue"],
      "size": ["S", "M", "L"],
      "categoryId": "uuid",
      "created_at": "timestamp"
    }
  ]
}

// Flutter Implementation
Future<List<Product>> getProducts() async {
  final token = await AuthService.to.getToken();
  final response = await http.get(
    Uri.parse('${ApiConfig.baseUrl}/api/mobile-app/products'),
    headers: ApiConfig.getHeaders(token),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return (data['data'] as List)
        .map((item) => Product.fromJson(item))
        .toList();
  }
  throw ApiException.fromResponse(response);
}
```

### Get Product by ID

```dart
GET /api/mobile-app/products/{productId}
Authorization: Bearer {token}

// Response (200)
{
  "status": "success",
  "data": {
    "id": "uuid",
    "name": "string",
    "description": "string",
    "price": "decimal",
    "image_urls": ["string"],
    "stock_quantity": 10,
    "colors": ["red", "blue"],
    "size": ["S", "M", "L"],
    "attributes": {},
    "reviews": [
      {
        "id": "uuid",
        "rating": 5,
        "content": "string",
        "appUser": {
          "name": "string"
        },
        "created_at": "timestamp"
      }
    ]
  }
}
```

## Cart Endpoints

### Get Cart

```dart
GET /api/mobile-app/cart
Authorization: Bearer {token}

// Response (200)
{
  "status": "success",
  "data": {
    "cart": {
      "id": "uuid",
      "storeId": "uuid",
      "appUserId": "uuid"
    },
    "items": [
      {
        "id": "uuid",
        "productId": "uuid",
        "quantity": 2,
        "variants": {
          "color": "red",
          "size": "M"
        },
        "product": {
          "id": "uuid",
          "name": "string",
          "price": "decimal",
          "image_urls": ["string"]
        }
      }
    ],
    "summary": {
      "totalItems": 3,
      "subtotal": 849.97,
      "uniqueItems": 2
    }
  }
}

// Flutter Implementation
Future<CartData> getCart() async {
  final token = await AuthService.to.getToken();
  final response = await http.get(
    Uri.parse('${ApiConfig.baseUrl}/api/mobile-app/cart'),
    headers: ApiConfig.getHeaders(token),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return CartData.fromJson(data['data']);
  }
  throw ApiException.fromResponse(response);
}
```

### Add to Cart

```dart
POST /api/mobile-app/products/cart/{productId}
Authorization: Bearer {token}

// Request
{
  "quantity": 1,
  "variants": {
    "color": "red",
    "size": "M"
  }
}

// Response (200)
{
  "status": "success",
  "message": "Product added to cart successfully",
  "data": {
    "cartItem": {
      "id": "uuid",
      "productId": "uuid",
      "quantity": 1,
      "variants": {
        "color": "red",
        "size": "M"
      }
    },
    "cartSummary": {
      "totalItems": 4,
      "subtotal": 949.97
    }
  }
}

// Flutter Implementation
Future<void> addToCart(String productId, int quantity, Map<String, dynamic> variants) async {
  final token = await AuthService.to.getToken();
  final response = await http.post(
    Uri.parse('${ApiConfig.baseUrl}/api/mobile-app/products/cart/$productId'),
    headers: ApiConfig.getHeaders(token),
    body: jsonEncode({
      'quantity': quantity,
      'variants': variants,
    }),
  );

  if (response.statusCode != 200) {
    throw ApiException.fromResponse(response);
  }
}
```

### Update Cart Item

```dart
PUT /api/mobile-app/cart/items/{itemId}
Authorization: Bearer {token}

// Request
{
  "quantity": 3,
  "variants": {
    "color": "blue",
    "size": "L"
  }
}

// Response (200)
{
  "status": "success",
  "message": "Cart item updated successfully"
}
```

### Remove Cart Item

```dart
DELETE /api/mobile-app/cart/items/{itemId}
Authorization: Bearer {token}

// Response (200)
{
  "status": "success",
  "message": "Item removed from cart successfully"
}
```

## Order Endpoints

### Create Order

```dart
POST /api/mobile-app/orders
Authorization: Bearer {token}

// Request
{
  "shippingAddress": {
    "firstName": "string",
    "lastName": "string",
    "street": "string",
    "city": "string",
    "state": "string",
    "zipCode": "string",
    "country": "string",
    "phone": "string"
  },
  "billingAddress": {
    "firstName": "string",
    "lastName": "string",
    "street": "string",
    "city": "string",
    "state": "string",
    "zipCode": "string",
    "country": "string"
  },
  "paymentMethod": "credit_card",
  "notes": "string"
}

// Response (200)
{
  "status": "success",
  "message": "Order created successfully",
  "data": {
    "orderId": "uuid",
    "orderNumber": "ORD-12345678-ABCD",
    "totalAmount": 440.00,
    "status": "pending",
    "paymentStatus": "pending"
  }
}

// Flutter Implementation
Future<String> createOrder(OrderRequest orderRequest) async {
  final token = await AuthService.to.getToken();
  final response = await http.post(
    Uri.parse('${ApiConfig.baseUrl}/api/mobile-app/orders'),
    headers: ApiConfig.getHeaders(token),
    body: jsonEncode(orderRequest.toJson()),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['data']['orderId'];
  }
  throw ApiException.fromResponse(response);
}
```

### Get User Orders

```dart
GET /api/mobile-app/orders
Authorization: Bearer {token}

// Response (200)
{
  "status": "success",
  "data": [
    {
      "id": "uuid",
      "orderNumber": "ORD-12345678-ABCD",
      "status": "pending",
      "paymentStatus": "pending",
      "totalAmount": 440.00,
      "itemCount": 3,
      "created_at": "timestamp",
      "updated_at": "timestamp"
    }
  ]
}
```

### Get Order Details

```dart
GET /api/mobile-app/orders/{orderId}
Authorization: Bearer {token}

// Response (200)
{
  "status": "success",
  "data": {
    "id": "uuid",
    "orderNumber": "ORD-12345678-ABCD",
    "status": "pending",
    "paymentStatus": "pending",
    "subtotal": 400.00,
    "tax": 40.00,
    "shippingCost": 0.00,
    "totalAmount": 440.00,
    "shippingAddress": {
      "firstName": "string",
      "lastName": "string",
      "street": "string",
      "city": "string",
      "state": "string",
      "zipCode": "string",
      "country": "string"
    },
    "items": [
      {
        "id": "uuid",
        "productId": "uuid",
        "productName": "string",
        "quantity": 2,
        "unitPrice": 100.00,
        "totalPrice": 200.00,
        "variants": {
          "color": "red",
          "size": "M"
        },
        "product": {
          "id": "uuid",
          "name": "string",
          "price": 100.00,
          "imageUrls": ["string"]
        }
      }
    ],
    "created_at": "timestamp",
    "updated_at": "timestamp"
  }
}
```

## Payment Endpoints

### Process Payment for Order

```dart
POST /api/mobile-app/orders/{orderId}/pay
Authorization: Bearer {token}

// Request
{
  "paymentMethod": "credit_card",
  "stripePaymentMethodId": "pm_1234567890",
  "savePaymentMethod": false
}

// Response (200) - Success
{
  "status": "success",
  "message": "Payment processed successfully",
  "data": {
    "paymentId": "uuid",
    "orderId": "uuid",
    "amount": 440.00,
    "status": "succeeded"
  }
}

// Response (200) - Requires Action (3D Secure)
{
  "status": "requires_action",
  "data": {
    "paymentId": "uuid",
    "clientSecret": "pi_1234567890_secret_abcdef",
    "paymentIntentId": "pi_1234567890"
  }
}

// Flutter Implementation
Future<PaymentResult> processPayment(String orderId, String paymentMethodId) async {
  final token = await AuthService.to.getToken();
  final response = await http.post(
    Uri.parse('${ApiConfig.baseUrl}/api/mobile-app/orders/$orderId/pay'),
    headers: {
      ...ApiConfig.getHeaders(token),
      'Idempotency-Key': 'order-$orderId-${DateTime.now().millisecondsSinceEpoch}',
    },
    body: jsonEncode({
      'paymentMethod': 'credit_card',
      'stripePaymentMethodId': paymentMethodId,
      'savePaymentMethod': false,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return PaymentResult.fromJson(data);
  }
  throw ApiException.fromResponse(response);
}
```

### Get Payment History

```dart
GET /api/mobile-app/payments
Authorization: Bearer {token}

// Response (200)
{
  "status": "success",
  "data": [
    {
      "id": "uuid",
      "order_id": "uuid",
      "amount": "440.00",
      "currency": "usd",
      "payment_method": "credit_card",
      "status": "succeeded",
      "payment_date": "timestamp",
      "created_at": "timestamp"
    }
  ]
}
```

### Get Payment Details

```dart
GET /api/mobile-app/payments/{paymentId}
Authorization: Bearer {token}

// Response (200)
{
  "status": "success",
  "data": {
    "id": "uuid",
    "order_id": "uuid",
    "amount": "440.00",
    "currency": "usd",
    "payment_method": "credit_card",
    "status": "succeeded",
    "payment_date": "timestamp",
    "stripePaymentIntentId": "pi_1234567890",
    "created_at": "timestamp",
    "updated_at": "timestamp"
  }
}
```

## Payment Methods Endpoints

### Get Saved Payment Methods

```dart
GET /api/mobile-app/payments/methods
Authorization: Bearer {token}

// Response (200)
{
  "status": "success",
  "data": [
    {
      "id": "uuid",
      "type": "credit_card",
      "stripePaymentMethodId": "pm_1234567890",
      "details": {
        "brand": "visa",
        "last4": "4242",
        "expiryMonth": "12",
        "expiryYear": "2025"
      },
      "isDefault": true,
      "created_at": "timestamp"
    }
  ]
}
```

### Save Payment Method

```dart
POST /api/mobile-app/payments/methods
Authorization: Bearer {token}

// Request
{
  "type": "credit_card",
  "stripePaymentMethodId": "pm_1234567890",
  "isDefault": false,
  "details": {
    "brand": "visa",
    "last4": "4242",
    "expiryMonth": "12",
    "expiryYear": "2025",
    "cardholderName": "John Doe"
  }
}

// Response (201)
{
  "status": "success",
  "message": "Payment method added successfully",
  "data": {
    "id": "uuid",
    "type": "credit_card",
    "stripePaymentMethodId": "pm_1234567890",
    "isDefault": false,
    "details": {
      "brand": "visa",
      "last4": "4242",
      "expiryMonth": "12",
      "expiryYear": "2025"
    }
  }
}
```

### Set Default Payment Method

```dart
PUT /api/mobile-app/payments/methods/{methodId}/default
Authorization: Bearer {token}

// Response (200)
{
  "status": "success",
  "message": "Default payment method updated successfully"
}
```

### Delete Payment Method

```dart
DELETE /api/mobile-app/payments/methods/{methodId}
Authorization: Bearer {token}

// Response (200)
{
  "status": "success",
  "message": "Payment method deleted successfully"
}
```

## Error Handling

### Standard Error Response Format

```dart
// Error Response (4xx, 5xx)
{
  "status": "error",
  "message": "Human readable error message",
  "errors": [
    {
      "field": "email",
      "message": "Email is required"
    }
  ]
}

// Flutter Exception Handling
class ApiException implements Exception {
  final int statusCode;
  final String message;
  final List<FieldError>? fieldErrors;

  static ApiException fromResponse(http.Response response) {
    final data = jsonDecode(response.body);
    return ApiException(
      statusCode: response.statusCode,
      message: data['message'] ?? 'Unknown error',
      fieldErrors: (data['errors'] as List?)
          ?.map((e) => FieldError.fromJson(e))
          .toList(),
    );
  }
}
```

### Common Error Codes

```dart
// Authentication Errors
401 Unauthorized - Invalid or expired token
403 Forbidden - User doesn't have permission

// Validation Errors
400 Bad Request - Invalid request data
422 Unprocessable Entity - Validation failed

// Resource Errors
404 Not Found - Resource not found
409 Conflict - Resource conflict (e.g., already in cart)

// Server Errors
500 Internal Server Error - Server side error
503 Service Unavailable - Service temporarily unavailable
```

## Data Models

### User Model

```dart
class User {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    avatar: json['avatar'],
    createdAt: DateTime.parse(json['created_at']),
  );
}
```

### Product Model

```dart
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> imageUrls;
  final int stockQuantity;
  final List<String> colors;
  final List<String> sizes;
  final Map<String, dynamic> attributes;
  final List<Review> reviews;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrls,
    required this.stockQuantity,
    required this.colors,
    required this.sizes,
    required this.attributes,
    required this.reviews,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    price: double.parse(json['price'].toString()),
    imageUrls: List<String>.from(json['image_urls'] ?? []),
    stockQuantity: json['stock_quantity'] ?? 0,
    colors: List<String>.from(json['colors'] ?? []),
    sizes: List<String>.from(json['size'] ?? []),
    attributes: json['attributes'] ?? {},
    reviews: (json['reviews'] as List?)
        ?.map((r) => Review.fromJson(r))
        .toList() ?? [],
  );
}
```

### Cart Models

```dart
class CartData {
  final Cart cart;
  final List<CartItem> items;
  final CartSummary summary;

  CartData({
    required this.cart,
    required this.items,
    required this.summary,
  });

  factory CartData.fromJson(Map<String, dynamic> json) => CartData(
    cart: Cart.fromJson(json['cart']),
    items: (json['items'] as List)
        .map((item) => CartItem.fromJson(item))
        .toList(),
    summary: CartSummary.fromJson(json['summary']),
  );
}

class CartItem {
  final String id;
  final String productId;
  final int quantity;
  final Map<String, dynamic> variants;
  final Product product;

  CartItem({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.variants,
    required this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    id: json['id'],
    productId: json['productId'],
    quantity: json['quantity'],
    variants: json['variants'] ?? {},
    product: Product.fromJson(json['product']),
  );
}

class CartSummary {
  final int totalItems;
  final double subtotal;
  final int uniqueItems;

  CartSummary({
    required this.totalItems,
    required this.subtotal,
    required this.uniqueItems,
  });

  factory CartSummary.fromJson(Map<String, dynamic> json) => CartSummary(
    totalItems: json['totalItems'],
    subtotal: json['subtotal'].toDouble(),
    uniqueItems: json['uniqueItems'],
  );
}
```

### Order Models

```dart
class Order {
  final String id;
  final String orderNumber;
  final String status;
  final String paymentStatus;
  final double subtotal;
  final double tax;
  final double shippingCost;
  final double totalAmount;
  final Address shippingAddress;
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
    required this.totalAmount,
    required this.shippingAddress,
    required this.items,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json['id'],
    orderNumber: json['orderNumber'],
    status: json['status'],
    paymentStatus: json['paymentStatus'],
    subtotal: json['subtotal'].toDouble(),
    tax: json['tax'].toDouble(),
    shippingCost: json['shippingCost'].toDouble(),
    totalAmount: json['totalAmount'].toDouble(),
    shippingAddress: Address.fromJson(json['shippingAddress']),
    items: (json['items'] as List)
        .map((item) => OrderItem.fromJson(item))
        .toList(),
    createdAt: DateTime.parse(json['created_at']),
  );
}
```

## Rate Limiting

### Request Limits

```dart
// Authentication endpoints: 5 requests per minute
// Cart operations: 30 requests per minute
// Product browsing: 100 requests per minute
// Payment processing: 10 requests per minute

// Implement exponential backoff for rate limited requests
class ApiClient {
  static Future<http.Response> requestWithRetry(
    Future<http.Response> Function() request,
    {int maxRetries = 3}
  ) async {
    for (int i = 0; i < maxRetries; i++) {
      try {
        final response = await request();
        if (response.statusCode == 429) {
          await Future.delayed(Duration(seconds: pow(2, i).toInt()));
          continue;
        }
        return response;
      } catch (e) {
        if (i == maxRetries - 1) rethrow;
        await Future.delayed(Duration(seconds: pow(2, i).toInt()));
      }
    }
    throw Exception('Max retries exceeded');
  }
}
```

---

This API reference provides everything needed for Flutter developers to integrate with the StoreGo platform. All endpoints are tested and working in production.
