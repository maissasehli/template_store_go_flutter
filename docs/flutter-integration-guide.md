# StoreGo Flutter Integration Guide

This document provides a comprehensive guide for integrating Stripe payments into generated Flutter apps. It covers what has been implemented on the StoreGo server-side and provides step-by-step instructions for Flutter developers.

## Table of Contents

1. [Server-Side Implementation Overview](#server-side-implementation-overview)
2. [What's Already Working](#whats-already-working)
3. [Flutter Integration Requirements](#flutter-integration-requirements)
4. [Implementation Strategy](#implementation-strategy)
5. [Code Templates](#code-templates)
6. [Testing Guide](#testing-guide)
7. [Deployment Considerations](#deployment-considerations)

## Server-Side Implementation Overview

### StoreGo Platform Status ✅

The StoreGo platform (Next.js/Hono backend) has been fully implemented with:

#### 1. Complete Payment System

- **Payment Processing**: Full Stripe integration for processing payments
- **Payment Methods**: Save, retrieve, and manage customer payment methods
- **Order Integration**: Complete cart-to-order-to-payment flow
- **Multi-tenant Security**: Store-isolated payment processing

#### 2. Fully Working API Endpoints

```typescript
// Payment Processing
POST   /api/mobile-app/orders/{orderId}/pay         // Process payment for order
GET    /api/mobile-app/payments                     // Get user's payment history
GET    /api/mobile-app/payments/{paymentId}         // Get specific payment details

// Payment Methods Management
GET    /api/mobile-app/payments/methods             // Get saved payment methods
POST   /api/mobile-app/payments/methods             // Save new payment method
DELETE /api/mobile-app/payments/methods/{id}        // Delete payment method
PUT    /api/mobile-app/payments/methods/{id}/default // Set default payment method

// Cart & Order Management
GET    /api/mobile-app/cart                         // Get user's cart
POST   /api/mobile-app/products/cart/{productId}    // Add to cart
POST   /api/mobile-app/orders                       // Create order from cart
GET    /api/mobile-app/orders/{orderId}             // Get order details

// Authentication
POST   /api/mobile-app/auth/sign-in                 // User authentication
POST   /api/mobile-app/auth/sign-up                 // User registration
POST   /api/mobile-app/auth/refresh                 // Token refresh
```

#### 3. Webhook Implementation

- **Stripe Webhooks**: Automatic payment status updates
- **Async Processing**: Handle 3D Secure and delayed payments
- **Error Recovery**: Automatic retry and failure handling

#### 4. Database Schema

- **Multi-tenant Architecture**: Store-isolated data
- **Payment Records**: Complete payment tracking
- **Order Management**: Full order lifecycle
- **Cart Persistence**: Reliable cart storage

## What's Already Working

### ✅ Complete E-commerce Flow

The following workflow is fully functional and tested:

1. **User Authentication** → Store-specific user login ✅
2. **Product Browsing** → Multi-tenant product catalog ✅
3. **Cart Management** → Add/update/remove cart items ✅
4. **Order Creation** → Convert cart to order ✅
5. **Payment Processing** → Real Stripe payment processing ✅
6. **Payment Confirmation** → Order status updates ✅

### ✅ Example API Test Results

```json
// Successful payment response from server
{
  "status": "success",
  "message": "Payment processed successfully",
  "data": {
    "paymentId": "89505483-6bb5-4926-8476-08cf6a7b6dda",
    "orderId": "82d94ef6-3727-4f1e-81c8-d487867834c2",
    "amount": 440,
    "status": "succeeded"
  }
}
```

### ✅ Security & Multi-tenancy

- **Store Isolation**: Each app only accesses its store's data
- **JWT Authentication**: Secure token-based authentication
- **Row-Level Security**: Database-enforced data isolation
- **Stripe Integration**: PCI-compliant payment processing

## Flutter Integration Requirements

### Dependencies

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_stripe: ^10.1.1
  http: ^1.1.0
  get: ^4.6.6 # Already included in StoreGo templates
  shared_preferences: ^2.2.2
```

### Environment Configuration

The generated Flutter app will include these configurations:

```dart
// lib/config/app_config.dart (Generated)
class AppConfig {
  static const String apiBaseUrl = 'https://store-go.vercel.app';
  static const String storeId = '{{STORE_ID}}'; // Injected during generation
  static const String stripePublishableKey = '{{STRIPE_PUBLISHABLE_KEY}}';
}
```

## Implementation Strategy

### Phase 1: UI Development (Start Now) 🚀

You can begin Flutter development immediately using the working APIs:

#### 1.1 Authentication Integration

```dart
// lib/services/auth_service.dart
class AuthService extends GetxService {
  Future<bool> signIn(String email, String password) async {
    final response = await http.post(
      Uri.parse('${AppConfig.apiBaseUrl}/api/mobile-app/auth/sign-in'),
      body: jsonEncode({
        'storeId': AppConfig.storeId,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        await _saveTokens(data['session']);
        return true;
      }
    }
    return false;
  }
}
```

#### 1.2 Cart Management Integration

```dart
// lib/services/cart_service.dart
class CartService extends GetxService {
  Future<void> addToCart(String productId, int quantity, Map<String, dynamic> variants) async {
    final token = await AuthService.to.getToken();

    final response = await http.post(
      Uri.parse('${AppConfig.apiBaseUrl}/api/mobile-app/products/cart/$productId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'quantity': quantity,
        'variants': variants,
      }),
    );

    if (response.statusCode == 200) {
      Get.snackbar('Success', 'Product added to cart');
      await getCart(); // Refresh cart
    }
  }
}
```

#### 1.3 Order Creation Integration

```dart
// lib/services/order_service.dart
class OrderService extends GetxService {
  Future<String?> createOrder(Map<String, dynamic> shippingAddress) async {
    final token = await AuthService.to.getToken();

    final response = await http.post(
      Uri.parse('${AppConfig.apiBaseUrl}/api/mobile-app/orders'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'shippingAddress': shippingAddress,
        'paymentMethod': 'credit_card',
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['orderId'];
    }
    return null;
  }
}
```

### Phase 2: Stripe Integration (Parallel Development) 💳

While UI development progresses, implement Stripe payment processing:

#### 2.1 Stripe Service

```dart
// lib/services/stripe_service.dart
class StripeService extends GetxService {
  @override
  Future<void> onInit() async {
    super.onInit();
    Stripe.publishableKey = AppConfig.stripePublishableKey;
    await Stripe.instance.applySettings();
  }

  Future<PaymentMethod> createPaymentMethod(CardFieldInputDetails cardDetails) async {
    return await Stripe.instance.createPaymentMethod(
      params: PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(),
      ),
    );
  }

  Future<Map<String, dynamic>> processPayment({
    required String orderId,
    required String paymentMethodId,
    required double amount,
  }) async {
    final token = await AuthService.to.getToken();

    final response = await http.post(
      Uri.parse('${AppConfig.apiBaseUrl}/api/mobile-app/orders/$orderId/pay'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Idempotency-Key': 'order-$orderId-${DateTime.now().millisecondsSinceEpoch}',
      },
      body: jsonEncode({
        'paymentMethod': 'credit_card',
        'stripePaymentMethodId': paymentMethodId,
        'savePaymentMethod': false,
      }),
    );

    final result = jsonDecode(response.body);

    // Handle 3D Secure if required
    if (result['status'] == 'requires_action') {
      await Stripe.instance.handleNextAction(result['data']['clientSecret']);
      return await _checkPaymentStatus(result['data']['paymentIntentId']);
    }

    return result;
  }
}
```

#### 2.2 Payment UI Components

```dart
// lib/widgets/payment_card_form.dart
class PaymentCardForm extends StatefulWidget {
  final Function(CardFieldInputDetails?) onCardChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardField(
          onCardChanged: onCardChanged,
          style: CardFormStyle(
            backgroundColor: Colors.white,
            textColor: Colors.black,
            placeholderColor: Colors.grey,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Your payment information is secured by Stripe',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
```

#### 2.3 Checkout Screen

```dart
// lib/screens/checkout_screen.dart
class CheckoutScreen extends StatelessWidget {
  final String orderId;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(title: Text('Checkout')),
        body: Column(
          children: [
            OrderSummaryCard(orderId: orderId, amount: amount),
            PaymentCardForm(onCardChanged: controller.onCardChanged),
            ElevatedButton(
              onPressed: controller.canPay
                ? () => controller.processPayment(orderId, amount)
                : null,
              child: controller.isProcessing
                ? CircularProgressIndicator()
                : Text('Pay \$${amount.toStringAsFixed(2)}'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Phase 3: Integration & Testing 🧪

#### 3.1 End-to-End Testing

```dart
// test/integration/payment_flow_test.dart
void main() {
  group('Payment Flow Integration', () {
    testWidgets('Complete purchase flow', (WidgetTester tester) async {
      // 1. Login
      await AuthService.to.signIn('test@example.com', 'password');

      // 2. Add to cart
      await CartService.to.addToCart('product-id', 1, {});

      // 3. Create order
      final orderId = await OrderService.to.createOrder(mockAddress);

      // 4. Process payment
      final result = await StripeService.to.processPayment(
        orderId: orderId!,
        paymentMethodId: 'pm_test_card',
        amount: 100.0,
      );

      expect(result['status'], 'success');
    });
  });
}
```

## Code Templates

### Template Structure for Generated Apps

```
lib/
├── config/
│   ├── app_config.dart          # Store & API configuration
│   └── stripe_config.dart       # Stripe settings
├── services/
│   ├── auth_service.dart        # Authentication
│   ├── cart_service.dart        # Cart management
│   ├── order_service.dart       # Order processing
│   ├── stripe_service.dart      # Payment processing
│   └── payment_service.dart     # Payment methods
├── controllers/
│   ├── auth_controller.dart     # Auth state management
│   ├── cart_controller.dart     # Cart state management
│   ├── checkout_controller.dart # Payment flow management
│   └── order_controller.dart    # Order management
├── widgets/
│   ├── payment_card_form.dart   # Card input form
│   ├── payment_method_tile.dart # Saved payment methods
│   └── order_summary_card.dart  # Order details
└── screens/
    ├── cart_screen.dart         # Shopping cart
    ├── checkout_screen.dart     # Payment processing
    ├── payment_success_screen.dart
    └── order_details_screen.dart
```

### Auto-Generated Configuration

```dart
// lib/config/app_config.dart (Auto-generated)
class AppConfig {
  // Generated from store configuration
  static const String storeId = '{{STORE_ID}}';
  static const String storeName = '{{STORE_NAME}}';
  static const String apiBaseUrl = 'https://store-go.vercel.app';

  // Stripe configuration
  static const String stripePublishableKey = 'pk_test_...';
  static const String merchantIdentifier = 'merchant.com.storego.{{STORE_ID}}';

  // App-specific settings
  static const String currency = '{{STORE_CURRENCY}}';
  static const bool enableApplePay = true;
  static const bool enableGooglePay = true;
}
```

## Testing Guide

### 1. Server-Side Testing (Already Complete) ✅

All server endpoints have been tested and are working:

```bash
# Authentication
✅ POST /api/mobile-app/auth/sign-in
✅ POST /api/mobile-app/auth/sign-up

# Cart Management
✅ GET /api/mobile-app/cart
✅ POST /api/mobile-app/products/cart/{productId}

# Order Processing
✅ POST /api/mobile-app/orders
✅ GET /api/mobile-app/orders/{orderId}

# Payment Processing
✅ POST /api/mobile-app/orders/{orderId}/pay
✅ GET /api/mobile-app/payments/{paymentId}
```

### 2. Flutter Testing Strategy

#### Unit Tests

```dart
// test/services/stripe_service_test.dart
void main() {
  group('StripeService', () {
    test('creates payment method successfully', () async {
      final service = StripeService();
      // Test payment method creation
    });

    test('processes payment with valid card', () async {
      // Test payment processing
    });
  });
}
```

#### Widget Tests

```dart
// test/widgets/payment_card_form_test.dart
void main() {
  testWidgets('PaymentCardForm displays correctly', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: PaymentCardForm(onCardChanged: (_) {}),
    ));

    expect(find.byType(CardField), findsOneWidget);
  });
}
```

#### Integration Tests

```dart
// integration_test/payment_flow_test.dart
void main() {
  group('Payment Flow', () {
    testWidgets('complete payment process', (tester) async {
      // Test full payment flow
    });
  });
}
```

### 3. Test Data

Use Stripe test cards for development:

```dart
class TestCards {
  static const String visa = '4242424242424242';
  static const String visaDebit = '4000056655665556';
  static const String threeDSecure = '4000002760003184';
  static const String declined = '4000000000000002';
}
```

## Deployment Considerations

### 1. Environment Configuration

```yaml
# Generated during GitHub Actions
environments:
  development:
    api_base_url: "http://localhost:3000"
    stripe_publishable_key: "pk_test_..."

  production:
    api_base_url: "https://store-go.vercel.app"
    stripe_publishable_key: "pk_live_..."
```

### 2. Security Checklist

- ✅ **API Keys**: Never include secret keys in Flutter app
- ✅ **HTTPS**: All API communications use HTTPS
- ✅ **Token Storage**: Secure token storage using flutter_secure_storage
- ✅ **Validation**: Server-side validation for all payments
- ✅ **Monitoring**: Error tracking and analytics

### 3. App Store Considerations

```dart
// iOS: Add to Info.plist
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <false/>
</dict>

// Android: Add to AndroidManifest.xml
<uses-permission android:name="android.permission.INTERNET" />
```

## Next Steps

### Immediate Actions (Start Now) 🚀

1. **Begin Flutter UI Development**

   - Use the working APIs to build cart and order screens
   - Implement authentication flow
   - Create product browsing functionality

2. **Set Up Development Environment**

   - Install Flutter Stripe SDK
   - Configure test environment
   - Set up debugging tools

3. **Create Basic Payment UI**
   - Build payment form components
   - Implement order summary displays
   - Create success/error screens

### Parallel Development 🔄

While building the UI, implement:

1. **Stripe Integration**

   - Add payment method creation
   - Implement 3D Secure handling
   - Create payment processing logic

2. **State Management**

   - Set up GetX controllers
   - Implement reactive cart updates
   - Handle payment states

3. **Error Handling**
   - Network error recovery
   - Payment failure handling
   - User feedback systems

### Final Integration 🎯

1. **End-to-End Testing**

   - Test complete purchase flows
   - Verify payment processing
   - Validate error scenarios

2. **Performance Optimization**

   - Optimize API calls
   - Implement caching strategies
   - Minimize app startup time

3. **Production Deployment**
   - Configure production Stripe keys
   - Set up monitoring and analytics
   - Deploy to app stores

## Support & Resources

### StoreGo APIs

- **Base URL**: `https://store-go.vercel.app`
- **Documentation**: Available in Bruno collection
- **Support**: All endpoints tested and working

### Stripe Resources

- **Flutter SDK**: https://pub.dev/packages/flutter_stripe
- **Documentation**: https://stripe.com/docs/payments/accept-a-payment
- **Test Cards**: https://stripe.com/docs/testing

### Development Tools

- **API Testing**: Bruno collection included
- **State Management**: GetX framework
- **HTTP Client**: Built-in Dart http package

---

**Ready to Start?** The server-side is complete and tested. Begin with Phase 1 (UI Development) using the working APIs, then add Stripe integration in parallel. Your generated Flutter apps will have a solid foundation to build upon! 🚀
