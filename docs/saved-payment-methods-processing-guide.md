# Saved Payment Methods Processing Guide

## Overview

This document provides guidance on handling the payment processing flow when using saved payment methods versus new payment methods in the StoreGo Flutter application. This serves as a reference for future development and debugging.

## Key Decision: Payment Processing Screen is Still Necessary

**IMPORTANT**: The payment processing screen (`payment_processing_screen.dart`) is still required even when using saved payment methods with existing `stripePaymentMethodId` from the database.

## Why Payment Processing Screen is Still Needed

### 1. 3D Secure Authentication

Even saved payment methods may require 3D Secure authentication depending on:

- Card issuer requirements
- Transaction amount
- Risk assessment by Stripe
- Regional regulations (e.g., EU Strong Customer Authentication)

### 2. Payment Status Handling

The backend payment API (`/api/mobile-app/orders/{orderId}/pay`) can return multiple statuses:

- `succeeded` - Payment completed successfully
- `requires_action` - 3D Secure or other authentication needed
- `processing` - Payment is being processed
- `failed` - Payment failed

### 3. User Experience Consistency

Provides consistent user feedback and loading states regardless of payment method source.

## Payment Flow Comparison

### New Payment Method Flow

```
Checkout → Payment Processing Screen → Collect Card Details → Create Payment Method → Process Payment → Handle 3D Secure (if needed) → Order Confirmation
```

### Saved Payment Method Flow

```
Checkout → Payment Processing Screen → Use Existing stripePaymentMethodId → Process Payment → Handle 3D Secure (if needed) → Order Confirmation
```

## Implementation Strategy

### Current Payment Processing Screen Architecture

The current implementation in `payment_processing_screen.dart` assumes new card entry. It should be modified to handle both scenarios:

#### For New Cards:

1. Show card input form (`PaymentCardForm`)
2. Collect card details
3. Create Stripe payment method
4. Process payment
5. Handle authentication if needed

#### For Saved Cards:

1. Skip card input form
2. Use existing `stripePaymentMethodId` from selected payment method
3. Process payment immediately
4. Handle authentication if needed

### Recommended Modifications

#### 1. Detect Payment Method Source

Add logic to determine if using saved payment method:

```dart
// Check if we have a saved payment method selected
bool get _usingSavedPaymentMethod {
  return Get.isRegistered<PaymentController>() &&
         Get.find<PaymentController>().selectedPaymentMethod.value != null;
}
```

#### 2. Conditional UI Rendering

Show card form only for new payment methods:

```dart
// Only show card form if not using saved payment method
if (!_usingSavedPaymentMethod) ...[
  PaymentCardForm(
    onCardChanged: (cardDetails) {
      setState(() {
        _cardDetails = cardDetails;
      });
    },
    enabled: !_isProcessing,
  ),
  SizedBox(height: 16),
]
```

#### 3. Modified Payment Processing Logic

Handle both payment method sources:

```dart
Future<void> _processPayment() async {
  setState(() {
    _isProcessing = true;
  });

  try {
    PaymentResult paymentResult;

    if (_usingSavedPaymentMethod) {
      // Use saved payment method
      final paymentController = Get.find<PaymentController>();
      final selectedMethod = paymentController.selectedPaymentMethod.value!;

      paymentResult = await checkoutController.processPaymentWithSavedMethod(
        orderId: orderId,
        total: amount,
        paymentMethodId: selectedMethod.stripePaymentMethodId!,
      );
    } else {
      // Use new card details
      paymentResult = await checkoutController.processPaymentForOrder(
        orderId: orderId,
        total: amount,
        cardDetails: _cardDetails!,
        savePaymentMethod: _savePaymentMethod,
      );
    }

    // Handle payment result (same for both flows)
    if (paymentResult.isSuccess) {
      // Navigate to order confirmation
    } else if (paymentResult.isRequiresAction) {
      // Handle 3D Secure authentication
      await checkoutController.handle3DSecure(paymentResult);
    }
  } catch (e) {
    // Handle errors
  } finally {
    setState(() {
      _isProcessing = false;
    });
  }
}
```

## API Integration Points

### Saved Payment Method API Call

When using saved payment methods, the API call structure:

```dart
POST /api/mobile-app/orders/{orderId}/pay
{
  "paymentMethod": "credit_card",
  "stripePaymentMethodId": "pm_1234567890abcdef", // From saved payment method
  "savePaymentMethod": false // Not applicable for saved methods
}
```

### Response Handling

Both new and saved payment methods can return the same response types:

```dart
// Success Response
{
  "status": "succeeded",
  "data": {
    "paymentId": "uuid",
    "orderId": "uuid",
    "amount": 440.00,
    "status": "succeeded"
  }
}

// Requires Action Response (3D Secure)
{
  "status": "requires_action",
  "data": {
    "paymentId": "uuid",
    "clientSecret": "pi_1234567890_secret_abcdef",
    "paymentIntentId": "pi_1234567890"
  }
}
```

## Code Files Involved

### Primary Files

- `lib/features/payment/view/screen/payment_processing_screen.dart` - Main payment processing UI
- `lib/features/checkout/controllers/checkout_controller.dart` - Payment orchestration logic
- `lib/features/payment/controller/payment_controller.dart` - Payment method management

### Supporting Files

- `lib/features/payment/repositories/payment_repository.dart` - Payment API calls
- `lib/features/payment/services/payment_service.dart` - Payment business logic
- `lib/features/payment/services/stripe_service.dart` - Stripe SDK integration

## Testing Scenarios

### Saved Payment Method Testing

1. **Successful Payment**: Use saved card with sufficient funds
2. **3D Secure Required**: Use test card `4000 0025 0000 3155` (saved)
3. **Payment Declined**: Use test card `4000 0000 0000 9995` (saved)
4. **Network Error**: Test with poor connectivity

### UI States to Test

1. **Loading State**: During payment processing
2. **Error Handling**: Failed payments
3. **3D Secure Flow**: Authentication popup
4. **Success Navigation**: Order confirmation

## Bruno API Documentation References

- `docs/bruno-api-docs/Orders/create-order.bru` - Order creation endpoint
- `docs/bruno-api-docs/Orders/pay-for-order.bru` - **Primary payment processing endpoint**
- `docs/bruno-api-docs/Orders/flutter-payment-api-integration-guide.md` - Complete integration guide

## Future Considerations

### Performance Optimizations

1. **Skip Card Form Rendering**: For saved payment methods
2. **Pre-validate Payment Methods**: Check if saved methods are still valid
3. **Implement Payment Intent Caching**: For repeat attempts

### Security Enhancements

1. **Payment Method Validation**: Verify saved methods before use
2. **Biometric Authentication**: For saved payment method usage
3. **Session Timeout**: For payment processing screens

### User Experience Improvements

1. **Payment Method Selection**: Allow changing payment method during processing
2. **Progress Indicators**: Show payment step progress
3. **Error Recovery**: Allow retry with different payment methods

## Conclusion

The payment processing screen serves as a critical orchestrator for both new and saved payment methods. While saved payment methods simplify the flow by skipping card collection, they still require proper handling of authentication, status management, and user feedback. The screen should be enhanced to intelligently handle both scenarios while maintaining a consistent user experience.

---

**Created**: May 27, 2025
**Last Updated**: May 27, 2025
**Version**: 1.0
**Author**: Development Team
