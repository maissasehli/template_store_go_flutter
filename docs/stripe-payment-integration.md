# Stripe Payment Integration for StoreGo

This document outlines the implementation of Stripe payment processing within the StoreGo e-commerce platform.

## Environment Setup Requirements

Add these environment variables to your `.env` file:

```
STRIPE_SECRET_KEY=sk_test_your_test_key
STRIPE_PUBLISHABLE_KEY=pk_test_your_test_key
STRIPE_WEBHOOK_SECRET=whsec_your_webhook_secret
```

## Payment Flow

1. **Client-side**:

   - Collect payment information using Stripe Elements or the Flutter Stripe SDK
   - Create a payment method token without sending card details to our server

2. **API Call**:

   - Send the payment method ID to the server with order details
   - Include idempotency key to prevent duplicate charges

3. **Server-side**:

   - Create a payment intent with Stripe and process the payment
   - Handle additional authentication requirements (3D Secure)
   - Process webhooks for asynchronous payment events

4. **Response**:
   - Return payment status or next actions to the client
   - Handle success, failure, or additional authentication scenarios

## Best Practices

### Idempotency Keys

To prevent duplicate charges due to network issues or retries, implement idempotency keys:

```typescript
// Server-side implementation
const paymentIntent = await stripe.paymentIntents.create(
  {
    amount: amountInCents,
    currency,
    payment_method: paymentMethodId,
    // Other parameters...
  },
  {
    idempotencyKey: `order-${orderId}-payment`, // Unique key per order
  },
);
```

### Automatic Payment Methods

For better payment method compatibility and to simplify integration:

```typescript
const paymentIntent = await stripe.paymentIntents.create({
  amount: amountInCents,
  currency,
  automatic_payment_methods: {
    enabled: true,
  },
  // Other parameters...
});
```

### Webhook Implementation

Set up webhooks to handle asynchronous payment events:

```typescript
// Example webhook handler
app.post("/webhook", async (c) => {
  const signature = c.req.header("Stripe-Signature");
  const body = await c.req.text();

  try {
    const event = stripe.webhooks.constructEvent(
      body,
      signature,
      process.env.STRIPE_WEBHOOK_SECRET,
    );

    switch (event.type) {
      case "payment_intent.succeeded":
        await handlePaymentSuccess(event.data.object);
        break;
      case "payment_intent.payment_failed":
        await handlePaymentFailure(event.data.object);
        break;
      // Handle other event types
    }

    return c.json({ received: true });
  } catch (error) {
    console.error("Webhook error:", error);
    return c.json({ error: "Webhook error" }, 400);
  }
});
```

## Database Schema

The StoreGo platform uses two primary tables for payment handling:

1. **`app_payment_method`** - For storing tokenized payment methods:

   - Payment method type (credit card, bank transfer, etc.)
   - Last four digits and expiration (for cards)
   - Stripe payment method ID (tokenized reference)
   - Default payment method flag

2. **`app_payment`** - For storing payment records:
   - Payment amount and currency
   - Payment status (pending, completed, failed)
   - Order reference
   - Stripe payment intent ID

## API Endpoints

- `POST /api/mobile-app/payments/process`: Process a payment with Stripe
- `GET /api/mobile-app/payments/methods`: Get saved payment methods
- `POST /api/mobile-app/payments/methods`: Save a payment method
- `POST /api/mobile-app/payments/webhook`: Handle Stripe webhook events

## Client Integration Guidelines

### Flutter Implementation

The Flutter app should use the official [Stripe Flutter SDK](https://pub.dev/packages/flutter_stripe):

```dart
// 1. Initialize Stripe in your app
void initStripe() {
  Stripe.publishableKey = stripePublishableKey;
  Stripe.merchantIdentifier = 'merchant.com.storego';
  Stripe.urlScheme = 'storego';
  await Stripe.instance.initPaymentSheet();
}

// 2. Create a payment method
final paymentMethod = await Stripe.instance.createPaymentMethod(
  params: PaymentMethodParams.card(
    paymentMethodData: PaymentMethodData(
      billingDetails: billingDetails,
    ),
  ),
);

// 3. Send to server and process payment
final response = await http.post(
  Uri.parse('$apiUrl/api/mobile-app/payments/process'),
  headers: {
    'Authorization': 'Bearer $token',
    'Idempotency-Key': 'order-$orderId-${DateTime.now().millisecondsSinceEpoch}',
  },
  body: json.encode({
    'orderId': orderId,
    'amount': amount,
    'currency': 'USD',
    'paymentMethodId': paymentMethod.id,
  }),
);

// 4. Handle response
final responseData = json.decode(response.body);
if (responseData['status'] == 'requires_action') {
  // Handle 3D Secure authentication
  await Stripe.instance.handleNextAction(responseData['data']['clientSecret']);

  // Check payment status after authentication
  final confirmResult = await checkPaymentStatus(responseData['data']['paymentIntentId']);
  // Handle final result
}
```

### Payment Method Type Detection

Improve payment method type detection by retrieving the actual type from Stripe:

```typescript
// Server-side
const paymentMethod = await stripe.paymentMethods.retrieve(paymentMethodId);
const paymentMethodType = paymentMethod.type; // 'card', 'bank_transfer', etc.
```

## Security Considerations

- Never expose Stripe secret keys in client-side code
- Always validate payment amounts on the server
- Use HTTPS for all communications
- Implement proper error handling and logging
- Store only tokenized payment method references
- Use webhooks with signature verification
- Implement rate limiting for payment endpoints

## Testing

Use Stripe test mode and test cards to verify your integration:

- **Test Card Success**: `4242 4242 4242 4242`
- **Test Card Authentication**: `4000 0025 0000 3155`
- **Test Card Decline**: `4000 0000 0000 9995`

## Resources

- [Stripe API Documentation](https://stripe.com/docs/api)
- [Stripe Elements](https://stripe.com/docs/stripe-js)
- [Stripe Flutter SDK](https://pub.dev/packages/flutter_stripe)
- [Payment Intents API](https://stripe.com/docs/api/payment_intents)
- [Testing Stripe Payments](https://stripe.com/docs/testing)
