# Flutter Stripe Implementation Guide for StoreGo

This guide outlines how to implement Stripe payment processing in the Flutter mobile app for StoreGo. It covers what has already been implemented on the server-side and provides step-by-step instructions for implementing the client-side integration.

## Server-Side Implementation Summary

The StoreGo backend already has the following Stripe functionality implemented:

1. **API Endpoint for Payment Processing**:
   - `POST /api/mobile-app/payments/process`
   - Accepts payment method ID, order ID, amount, and currency
   - Creates Stripe Payment Intent and handles confirmation

2. **3D Secure Authentication Handling**:
   - Identifies transactions requiring additional authentication
   - Returns client secret for the Flutter app to complete authentication

3. **Environment Configuration**:
   - Stripe secret key (server-side only)
   - Stripe publishable key (can be shared with client)
   - Webhook secret for handling webhooks

4. **Database Integration**:
   - Stores payment records in `app_payment` table
   - Links payments to orders and customers

5. **Error Handling**:
   - Handles Stripe-specific errors
   - Returns appropriate error messages and status codes

## Flutter App Implementation Requirements

### 1. Add Dependencies

Add the Flutter Stripe SDK to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_stripe: ^latest_version # Use the latest version available
  http: ^latest_version # For API calls
```

### 2. Initialize Stripe

Add the following code to initialize Stripe in your app, typically in `main.dart` or during app startup:

```dart
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> initStripe() async {
  // Set the publishable key from environment variables or config
  Stripe.publishableKey = 'YOUR_PUBLISHABLE_KEY'; // This will come from your .env or config
  
  // Optional: Set merchant identifier for Apple Pay
  Stripe.merchantIdentifier = 'merchant.com.storego';
  
  // Configure payment sheet if needed
  await Stripe.instance.applySettings();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initStripe();
  runApp(MyApp());
}
```

### 3. Create Payment Service

Create a service class to handle payment operations:

```dart
class PaymentService {
  final String baseUrl = 'https://your-api-url.com'; // Replace with actual API URL
  
  // Create a payment method using Stripe SDK
  Future<PaymentMethodData> createPaymentMethod({
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvc,
    String? name,
    BillingDetails? billingDetails,
  }) async {
    final paymentMethod = await Stripe.instance.createPaymentMethod(
      params: PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(
          billingDetails: billingDetails,
        ),
        card: CardParams(
          number: cardNumber,
          cvc: cvc,
          expirationMonth: int.parse(expiryMonth),
          expirationYear: int.parse(expiryYear),
        ),
      ),
    );
    
    return paymentMethod;
  }
  
  // Process payment through StoreGo API
  Future<Map<String, dynamic>> processPayment({
    required String paymentMethodId,
    required String orderId,
    required double amount,
    String currency = 'usd',
    String? description,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/mobile-app/payments/process'),
      headers: {
        'Authorization': 'Bearer $token', // Get token from your auth service
        'Content-Type': 'application/json',
        'Idempotency-Key': 'order-$orderId-${DateTime.now().millisecondsSinceEpoch}',
      },
      body: jsonEncode({
        'orderId': orderId,
        'amount': amount,
        'currency': currency,
        'paymentMethodId': paymentMethodId,
        'description': description,
      }),
    );
    
    final responseData = jsonDecode(response.body);
    
    // Handle 3D Secure authentication if required
    if (responseData['status'] == 'requires_action') {
      final clientSecret = responseData['data']['clientSecret'];
      await handle3dSecure(clientSecret);
      
      // After 3D Secure, check payment status
      return await checkPaymentStatus(responseData['data']['paymentIntentId']);
    }
    
    return responseData;
  }
  
  // Handle 3D Secure authentication
  Future<void> handle3dSecure(String clientSecret) async {
    try {
      await Stripe.instance.handleNextAction(clientSecret);
    } catch (e) {
      throw Exception('3D Secure authentication failed: ${e.toString()}');
    }
  }
  
  // Check payment status after 3D Secure
  Future<Map<String, dynamic>> checkPaymentStatus(String paymentIntentId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/mobile-app/payments/$paymentIntentId'),
      headers: {
        'Authorization': 'Bearer $token', // Get token from your auth service
      },
    );
    
    return jsonDecode(response.body);
  }
}
```

### 4. Create Payment UI Components

#### Card Input Form

Create a card input form component:

```dart
class PaymentCardForm extends StatefulWidget {
  final Function(CardFormEditController) onCardChange;
  final Function() onSubmit;

  const PaymentCardForm({
    Key? key,
    required this.onCardChange,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _PaymentCardFormState createState() => _PaymentCardFormState();
}

class _PaymentCardFormState extends State<PaymentCardForm> {
  final CardFormEditController cardController = CardFormEditController();

  @override
  void initState() {
    super.initState();
    cardController.addListener(() {
      widget.onCardChange(cardController);
    });
  }

  @override
  void dispose() {
    cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardFormField(
          controller: cardController,
          style: CardFormStyle(
            textColor: Colors.black,
            placeholderColor: Colors.grey,
            backgroundColor: Colors.white,
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: cardController.details.complete ? widget.onSubmit : null,
          child: Text('Pay'),
        ),
      ],
    );
  }
}
```

### 5. Implement Payment Flow in Checkout Screen

Create a checkout screen that utilizes the payment service:

```dart
class CheckoutScreen extends StatefulWidget {
  final String orderId;
  final double amount;

  const CheckoutScreen({
    Key? key,
    required this.orderId,
    required this.amount,
  }) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final PaymentService _paymentService = PaymentService();
  bool _isLoading = false;
  String? _errorMessage;
  CardFormEditController? _cardController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Total: \$${widget.amount.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text('Payment Details', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  PaymentCardForm(
                    onCardChange: (controller) {
                      setState(() {
                        _cardController = controller;
                      });
                    },
                    onSubmit: _processPayment,
                  ),
                  if (_errorMessage != null)
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Future<void> _processPayment() async {
    if (_cardController == null || !_cardController!.details.complete) {
      setState(() {
        _errorMessage = 'Please enter complete card information';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Create a payment method using the card controller
      final paymentMethod = await _createPaymentMethod();
      
      // Process the payment
      final result = await _paymentService.processPayment(
        paymentMethodId: paymentMethod.id,
        orderId: widget.orderId,
        amount: widget.amount,
      );
      
      if (result['status'] == 'success') {
        // Payment successful, navigate to success page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentSuccessScreen(orderId: widget.orderId),
          ),
        );
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Payment failed';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<PaymentMethodData> _createPaymentMethod() async {
    // Use your payment service to create a payment method
    // This is a simplified example - in a real app you would collect
    // billing details and other information
    final paymentMethod = await Stripe.instance.createPaymentMethod(
      params: PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(),
      ),
    );
    
    return paymentMethod;
  }
}
```

### 6. Create Success and Error Screens

Create screens to handle payment results:

```dart
class PaymentSuccessScreen extends StatelessWidget {
  final String orderId;

  const PaymentSuccessScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment Successful')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 80),
            SizedBox(height: 20),
            Text(
              'Payment Successful!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Order ID: $orderId'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to order tracking or home page
                Navigator.pushNamedAndRemoveUntil(
                  context, '/orders', (route) => false);
              },
              child: Text('View My Orders'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Testing Implementation

Use Stripe test cards to verify your implementation:

- **Successful payment**: 4242 4242 4242 4242
- **Requires authentication (3D Secure)**: 4000 0025 0000 3155
- **Payment declined**: 4000 0000 0000 9995

Other test information:
- Any future expiration date
- Any 3-digit CVC
- Any postal code

## Security Considerations

1. **Never store card details** in your app or backend
2. **Use HTTPS** for all API communications
3. **Only use the publishable key** in the Flutter app, never the secret key
4. **Implement idempotency keys** to prevent duplicate charges
5. **Validate all inputs** before sending to the payment service
6. **Implement proper error handling** for payment failures

## Troubleshooting Common Issues

1. **Payment method creation fails**:
   - Verify the card details are valid
   - Ensure you're using the correct publishable key

2. **3D Secure authentication fails**:
   - Check your return URL configuration
   - Ensure the app can handle the authentication redirect

3. **Payment is successful but order isn't created**:
   - Check the webhook implementation on the server
   - Verify the payment status is properly checked after authentication

4. **"Requires action" status is returned but no action is taken**:
   - Ensure you're properly handling the client secret
   - Verify the `handleNextAction` method is called

## Additional Resources

- [Flutter Stripe SDK Documentation](https://pub.dev/packages/flutter_stripe)
- [Stripe API Documentation](https://stripe.com/docs/api)
- [Testing Stripe Payments](https://stripe.com/docs/testing)
- [3D Secure Authentication Guide](https://stripe.com/docs/payments/3d-secure)
