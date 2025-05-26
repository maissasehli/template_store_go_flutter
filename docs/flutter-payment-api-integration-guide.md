# Flutter Payment API Integration Guide for StoreGo

## Overview

This guide provides Flutter developers with comprehensive instructions to integrate with StoreGo's payment API. StoreGo offers a robust payment system with Stripe integration, supporting multiple payment methods including credit cards, debit cards, PayPal, Apple Pay, and Google Pay.

## Table of Contents

- [Getting Started](#getting-started)
- [Authentication](#authentication)
- [API Base Configuration](#api-base-configuration)
- [Payment Endpoints](#payment-endpoints)
- [Flutter Implementation](#flutter-implementation)
- [Payment Flow](#payment-flow)
- [Error Handling](#error-handling)
- [Security Best Practices](#security-best-practices)
- [Testing](#testing)

## Getting Started

### Prerequisites

- Flutter SDK
- Stripe Flutter SDK (`flutter_stripe`)
- HTTP client package (`dio` or `http`)
- Secure storage package (`flutter_secure_storage`)

### Dependencies

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_stripe: ^10.1.1
  dio: ^5.3.2
  flutter_secure_storage: ^9.0.0
  json_annotation: ^4.8.1

dev_dependencies:
  json_serializable: ^6.7.1
  build_runner: ^2.4.7
```

## Authentication

StoreGo uses JWT Bearer token authentication. All payment API requests require a valid JWT token.

### Authentication Headers

```dart
Map<String, String> getAuthHeaders(String token) {
  return {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };
}
```

### Token Storage

```dart
class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'jwt_token';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
```

## API Base Configuration

### Base URL and Configuration

```dart
class ApiConfig {
  static const String baseUrl = 'https://store-go.vercel.app';
  static const String apiPath = '/api/mobile-app';

  // Payment endpoints
  static const String paymentsEndpoint = '$apiPath/payments';
  static const String paymentMethodsEndpoint = '$paymentsEndpoint/methods';

  static String orderPaymentEndpoint(String orderId) =>
      '$apiPath/orders/$orderId/pay';
}
```

### HTTP Client Setup

```dart
class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));

    // Add interceptor for authentication
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await AuthService.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    ));
  }

  Dio get dio => _dio;
}
```

## Payment Endpoints

### 1. Get All Payments

**Endpoint:** `GET /api/mobile-app/payments`

```dart
class PaymentService {
  final ApiClient _apiClient = ApiClient();

  Future<List<Payment>> getAllPayments() async {
    try {
      final response = await _apiClient.dio.get(ApiConfig.paymentsEndpoint);

      if (response.data['status'] == 'success') {
        final List<dynamic> paymentsJson = response.data['data'];
        return paymentsJson.map((json) => Payment.fromJson(json)).toList();
      }
      throw Exception('Failed to fetch payments');
    } catch (e) {
      throw Exception('Error fetching payments: $e');
    }
  }
}
```

### 2. Get Payment Methods

**Endpoint:** `GET /api/mobile-app/payments/methods`

```dart
Future<List<PaymentMethod>> getPaymentMethods() async {
  try {
    final response = await _apiClient.dio.get(ApiConfig.paymentMethodsEndpoint);

    if (response.data['status'] == 'success') {
      final List<dynamic> methodsJson = response.data['data'];
      return methodsJson.map((json) => PaymentMethod.fromJson(json)).toList();
    }
    throw Exception('Failed to fetch payment methods');
  } catch (e) {
    throw Exception('Error fetching payment methods: $e');
  }
}
```

### 3. Add Payment Method

**Endpoint:** `POST /api/mobile-app/payments/methods`

```dart
Future<PaymentMethod> addPaymentMethod({
  required String type,
  required String stripePaymentMethodId,
  bool? isDefault,
  Map<String, dynamic>? details,
}) async {
  try {
    final data = {
      'type': type,
      'stripePaymentMethodId': stripePaymentMethodId,
      if (isDefault != null) 'isDefault': isDefault,
      if (details != null) 'details': details,
    };

    final response = await _apiClient.dio.post(
      ApiConfig.paymentMethodsEndpoint,
      data: data,
    );

    if (response.data['status'] == 'success') {
      return PaymentMethod.fromJson(response.data['data']);
    }
    throw Exception('Failed to add payment method');
  } catch (e) {
    throw Exception('Error adding payment method: $e');
  }
}
```

### 4. Pay for Order

**Endpoint:** `POST /api/mobile-app/orders/{orderId}/pay`

```dart
Future<PaymentResult> payForOrder({
  required String orderId,
  required String paymentMethod,
  String? paymentToken,
  bool? savePaymentMethod,
}) async {
  try {
    final data = {
      'paymentMethod': paymentMethod,
      if (paymentToken != null) 'paymentToken': paymentToken,
      if (savePaymentMethod != null) 'savePaymentMethod': savePaymentMethod,
    };

    final response = await _apiClient.dio.post(
      ApiConfig.orderPaymentEndpoint(orderId),
      data: data,
    );

    return PaymentResult.fromJson(response.data);
  } catch (e) {
    throw Exception('Error processing payment: $e');
  }
}
```

## Flutter Implementation

### Data Models

```dart
// Payment Model
@JsonSerializable()
class Payment {
  final String id;
  final String orderId;
  final double amount;
  final String currency;
  final String paymentMethod;
  final String status;
  final DateTime paymentDate;
  final String? stripePaymentIntentId;

  Payment({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.paymentMethod,
    required this.status,
    required this.paymentDate,
    this.stripePaymentIntentId,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}

// Payment Method Model
@JsonSerializable()
class PaymentMethod {
  final String id;
  final String type;
  final String stripePaymentMethodId;
  final bool isDefault;
  final PaymentMethodDetails? details;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.stripePaymentMethodId,
    required this.isDefault,
    this.details,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);
}

@JsonSerializable()
class PaymentMethodDetails {
  final String? brand;
  final String? last4;
  final String? expiryMonth;
  final String? expiryYear;
  final String? cardholderName;
  final String? email;

  PaymentMethodDetails({
    this.brand,
    this.last4,
    this.expiryMonth,
    this.expiryYear,
    this.cardholderName,
    this.email,
  });

  factory PaymentMethodDetails.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentMethodDetailsToJson(this);
}

// Payment Result Model
@JsonSerializable()
class PaymentResult {
  final String status;
  final String message;
  final PaymentResultData? data;

  PaymentResult({
    required this.status,
    required this.message,
    this.data,
  });

  factory PaymentResult.fromJson(Map<String, dynamic> json) =>
      _$PaymentResultFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentResultToJson(this);
}

@JsonSerializable()
class PaymentResultData {
  final String? paymentId;
  final String? orderId;
  final double? amount;
  final String? status;
  final String? paymentIntentId;
  final String? clientSecret;

  PaymentResultData({
    this.paymentId,
    this.orderId,
    this.amount,
    this.status,
    this.paymentIntentId,
    this.clientSecret,
  });

  factory PaymentResultData.fromJson(Map<String, dynamic> json) =>
      _$PaymentResultDataFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentResultDataToJson(this);
}
```

### Stripe Integration

```dart
class StripeService {
  static Future<void> initialize() async {
    Stripe.publishableKey = 'pk_test_your_publishable_key_here';
    await Stripe.instance.applySettings();
  }

  static Future<String?> createPaymentMethod({
    required CardFieldInputDetails cardDetails,
  }) async {
    try {
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: const BillingDetails(),
          ),
        ),
      );

      return paymentMethod.id;
    } catch (e) {
      throw Exception('Failed to create payment method: $e');
    }
  }

  static Future<bool> confirmPayment({
    required String clientSecret,
    required String paymentMethodId,
  }) async {
    try {
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: const BillingDetails(),
          ),
        ),
      );
      return true;
    } catch (e) {
      throw Exception('Payment confirmation failed: $e');
    }
  }
}
```

## Payment Flow

### Complete Payment Flow Implementation

```dart
class PaymentFlowService {
  final PaymentService _paymentService = PaymentService();
  final StripeService _stripeService = StripeService();

  Future<bool> processOrderPayment({
    required String orderId,
    required CardFieldInputDetails cardDetails,
    bool savePaymentMethod = false,
  }) async {
    try {
      // Step 1: Create Stripe payment method
      final stripePaymentMethodId = await StripeService.createPaymentMethod(
        cardDetails: cardDetails,
      );

      if (stripePaymentMethodId == null) {
        throw Exception('Failed to create payment method');
      }

      // Step 2: Process payment with StoreGo API
      final paymentResult = await _paymentService.payForOrder(
        orderId: orderId,
        paymentMethod: stripePaymentMethodId,
        savePaymentMethod: savePaymentMethod,
      );

      // Step 3: Handle payment result
      if (paymentResult.status == 'success') {
        return true;
      } else if (paymentResult.status == 'requires_action') {
        // Handle 3D Secure authentication
        if (paymentResult.data?.clientSecret != null) {
          return await StripeService.confirmPayment(
            clientSecret: paymentResult.data!.clientSecret!,
            paymentMethodId: stripePaymentMethodId,
          );
        }
      }

      throw Exception(paymentResult.message);
    } catch (e) {
      throw Exception('Payment processing failed: $e');
    }
  }
}
```

### UI Implementation Example

```dart
class PaymentScreen extends StatefulWidget {
  final String orderId;
  final double amount;

  const PaymentScreen({
    Key? key,
    required this.orderId,
    required this.amount,
  }) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final PaymentFlowService _paymentFlowService = PaymentFlowService();
  CardFieldInputDetails? _cardDetails;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Amount: \$${widget.amount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            CardField(
              onCardChanged: (card) {
                setState(() {
                  _cardDetails = card;
                });
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _cardDetails?.complete == true && !_isProcessing
                    ? _processPayment
                    : null,
                child: _isProcessing
                    ? const CircularProgressIndicator()
                    : const Text('Pay Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processPayment() async {
    if (_cardDetails == null || !_cardDetails!.complete) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final success = await _paymentFlowService.processOrderPayment(
        orderId: widget.orderId,
        cardDetails: _cardDetails!,
        savePaymentMethod: false,
      );

      if (success) {
        // Navigate to success screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => PaymentSuccessScreen(orderId: widget.orderId),
          ),
        );
      }
    } catch (e) {
      // Show error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Payment Failed'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }
}
```

## Error Handling

### Common Error Responses

```dart
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  ApiException(this.message, {this.statusCode, this.errors});

  @override
  String toString() => 'ApiException: $message';
}

class ErrorHandler {
  static void handleApiError(DioException error) {
    if (error.response != null) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        throw ApiException(
          data['message'] ?? 'Unknown error occurred',
          statusCode: error.response?.statusCode,
          errors: data['errors'],
        );
      }
    }
    throw ApiException('Network error: ${error.message}');
  }
}
```

### Error Types and Handling

```dart
enum PaymentErrorType {
  networkError,
  authenticationError,
  validationError,
  paymentDeclined,
  insufficientFunds,
  unknownError,
}

class PaymentError {
  final PaymentErrorType type;
  final String message;
  final Map<String, dynamic>? details;

  PaymentError({
    required this.type,
    required this.message,
    this.details,
  });

  static PaymentError fromException(Exception e) {
    if (e is ApiException) {
      switch (e.statusCode) {
        case 400:
          return PaymentError(
            type: PaymentErrorType.validationError,
            message: e.message,
            details: e.errors,
          );
        case 401:
          return PaymentError(
            type: PaymentErrorType.authenticationError,
            message: 'Authentication failed',
          );
        case 402:
          return PaymentError(
            type: PaymentErrorType.paymentDeclined,
            message: 'Payment was declined',
          );
        default:
          return PaymentError(
            type: PaymentErrorType.unknownError,
            message: e.message,
          );
      }
    }

    return PaymentError(
      type: PaymentErrorType.networkError,
      message: e.toString(),
    );
  }
}
```

## Security Best Practices

### 1. Token Management

- Store JWT tokens securely using `flutter_secure_storage`
- Implement token refresh mechanism
- Clear tokens on logout

### 2. Network Security

```dart
// Use certificate pinning for production
class SecureApiClient extends ApiClient {
  SecureApiClient() : super() {
    // Add certificate pinning
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) {
        // Implement certificate validation
        return _validateCertificate(cert, host);
      };
      return client;
    };
  }

  bool _validateCertificate(X509Certificate cert, String host) {
    // Implement certificate pinning logic
    return true; // Replace with actual validation
  }
}
```

### 3. Sensitive Data Handling

- Never log sensitive payment information
- Use Stripe's tokenization for card data
- Validate all inputs client-side and server-side

### 4. PCI Compliance

- Use Stripe's secure elements for card input
- Never store card numbers in your app
- Follow PCI DSS guidelines

## Testing

### Unit Tests

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockPaymentService extends Mock implements PaymentService {}

void main() {
  group('PaymentFlowService Tests', () {
    late PaymentFlowService paymentFlowService;
    late MockPaymentService mockPaymentService;

    setUp(() {
      mockPaymentService = MockPaymentService();
      paymentFlowService = PaymentFlowService();
    });

    test('should process payment successfully', () async {
      // Arrange
      const orderId = 'test_order_123';
      const cardDetails = CardFieldInputDetails(complete: true);

      when(mockPaymentService.payForOrder(
        orderId: orderId,
        paymentMethod: anyNamed('paymentMethod'),
        savePaymentMethod: false,
      )).thenAnswer((_) async => PaymentResult(
        status: 'success',
        message: 'Payment successful',
      ));

      // Act
      final result = await paymentFlowService.processOrderPayment(
        orderId: orderId,
        cardDetails: cardDetails,
      );

      // Assert
      expect(result, isTrue);
    });
  });
}
```

### Integration Tests

```dart
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Payment Integration Tests', () {
    testWidgets('should complete payment flow', (WidgetTester tester) async {
      // Set up test environment
      await tester.pumpWidget(MyApp());

      // Navigate to payment screen
      await tester.tap(find.text('Pay Now'));
      await tester.pumpAndSettle();

      // Fill in card details (using test card)
      await tester.enterText(
        find.byType(CardField),
        '4242424242424242', // Test card number
      );

      // Submit payment
      await tester.tap(find.text('Submit Payment'));
      await tester.pumpAndSettle();

      // Verify success
      expect(find.text('Payment Successful'), findsOneWidget);
    });
  });
}
```

## Supported Payment Methods

StoreGo supports the following payment methods:

- **Credit Card** (`credit_card`)
- **Debit Card** (`debit_card`)
- **PayPal** (`paypal`)
- **Apple Pay** (`apple_pay`)
- **Google Pay** (`google_pay`)

## API Response Examples

### Successful Payment Response

```json
{
  "status": "success",
  "message": "Payment processed successfully",
  "data": {
    "paymentId": "pay_1234567890",
    "orderId": "order_123",
    "amount": 99.99,
    "status": "succeeded"
  }
}
```

### Error Response

```json
{
  "status": "error",
  "message": "Invalid payment data",
  "errors": [
    {
      "field": "paymentMethod",
      "message": "Payment method is required"
    }
  ]
}
```

### 3D Secure Required Response

```json
{
  "status": "requires_action",
  "message": "Additional authentication required",
  "data": {
    "paymentId": "pay_1234567890",
    "paymentIntentId": "pi_1234567890",
    "clientSecret": "pi_1234567890_secret_abcd"
  }
}
```

## Support and Documentation

For additional support and detailed API documentation:

- **API Documentation**: Available in the Bruno collection
- **Stripe Documentation**: [https://stripe.com/docs/flutter](https://stripe.com/docs/flutter)
- **StoreGo Support**: Contact the development team

## Changelog

- **v1.0.0**: Initial implementation guide
- **v1.1.0**: Added 3D Secure support
- **v1.2.0**: Enhanced error handling and security practices

---

This guide provides a complete foundation for integrating StoreGo's payment API into your Flutter application. For specific implementation questions or custom requirements, please consult the development team.
