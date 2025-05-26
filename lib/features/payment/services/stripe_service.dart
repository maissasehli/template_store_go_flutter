import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:logger/logger.dart';
import '../models/payment_result_model.dart';

class StripeService {
  final Logger _logger = Logger();

  StripeService();

  /// Initialize Stripe with publishable key
  Future<void> initialize(String publishableKey) async {
    try {
      Stripe.publishableKey = publishableKey;
      _logger.i('Stripe initialized successfully');
    } catch (e) {
      _logger.e('Error initializing Stripe: $e');
      throw Exception('Failed to initialize Stripe: $e');
    }
  }

  /// Create a payment method using Stripe SDK
  Future<PaymentMethod> createPaymentMethod({
    required PaymentMethodParams params,
  }) async {
    try {
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: params,
      );

      _logger.i('Payment method created: ${paymentMethod.id}');
      return paymentMethod;
    } catch (e) {
      _logger.e('Error creating payment method: $e');
      throw Exception('Failed to create payment method: $e');
    }
  }

  /// Create a card payment method
  Future<PaymentMethod> createCardPaymentMethod({
    required String cardNumber,
    required int expiryMonth,
    required int expiryYear,
    required String cvc,
    BillingDetails? billingDetails,
  }) async {
    try {
      final params = PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(billingDetails: billingDetails),
      );

      return await createPaymentMethod(params: params);
    } catch (e) {
      _logger.e('Error creating card payment method: $e');
      throw Exception('Failed to create card payment method: $e');
    }
  }

  /// Confirm a payment intent
  Future<PaymentResult> confirmPayment({
    required String paymentIntentClientSecret,
    PaymentMethodParams? paymentMethodParams,
    PaymentMethodOptions? options,
  }) async {
    try {
      final result = await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: paymentIntentClientSecret,
        data: paymentMethodParams,
        options: options,
      );

      switch (result.status) {
        case PaymentIntentsStatus.Succeeded:
          return PaymentResult.success(
            paymentIntentId: result.id,
            message: 'Payment completed successfully',
          );
        case PaymentIntentsStatus.RequiresAction:
          return PaymentResult.requiresAction(
            clientSecret: paymentIntentClientSecret,
            paymentIntentId: result.id,
            message: 'Additional authentication required',
          );
        case PaymentIntentsStatus.Processing:
          return PaymentResult.processing(
            message: 'Payment is being processed',
          );
        default:
          return PaymentResult.failed(
            error: 'Payment failed with status: ${result.status}',
            message: 'Payment could not be completed',
          );
      }
    } catch (e) {
      _logger.e('Error confirming payment: $e');
      return PaymentResult.failed(
        error: e.toString(),
        message: 'Payment confirmation failed: $e',
      );
    }
  }

  /// Handle next action for payment intent (e.g., 3D Secure)
  Future<PaymentResult> handleNextAction({
    required String paymentIntentClientSecret,
  }) async {
    try {
      final result = await Stripe.instance.handleNextAction(
        paymentIntentClientSecret,
      );

      switch (result.status) {
        case PaymentIntentsStatus.Succeeded:
          return PaymentResult.success(
            paymentIntentId: result.id,
            message: 'Payment completed successfully',
          );
        case PaymentIntentsStatus.RequiresAction:
          return PaymentResult.requiresAction(
            clientSecret: paymentIntentClientSecret,
            paymentIntentId: result.id,
            message: 'Additional authentication required',
          );
        case PaymentIntentsStatus.Processing:
          return PaymentResult.processing(
            message: 'Payment is being processed',
          );
        default:
          return PaymentResult.failed(
            error: 'Payment failed with status: ${result.status}',
            message: 'Payment authentication failed',
          );
      }
    } catch (e) {
      _logger.e('Error handling next action: $e');
      return PaymentResult.failed(
        error: e.toString(),
        message: 'Payment authentication failed: $e',
      );
    }
  }

  /// Present payment sheet
  Future<PaymentResult> presentPaymentSheet({
    required String paymentIntentClientSecret,
    String? ephemeralKeySecret,
    String? customerId,
    String? merchantDisplayName,
  }) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          customerId: customerId,
          merchantDisplayName: merchantDisplayName ?? 'Store Go',
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      return PaymentResult.success(message: 'Payment completed successfully');
    } catch (e) {
      _logger.e('Error presenting payment sheet: $e');

      if (e is StripeException) {
        switch (e.error.code) {
          case FailureCode.Canceled:
            return PaymentResult.failed(
              error: 'Payment was cancelled',
              message: 'Payment was cancelled by user',
            );
          case FailureCode.Failed:
            return PaymentResult.failed(
              error: e.error.message ?? 'Payment failed',
              message: 'Payment failed',
            );
          default:
            return PaymentResult.failed(
              error: e.error.message ?? 'Unknown error',
              message: 'Payment failed with error: ${e.error.code}',
            );
        }
      }

      return PaymentResult.failed(
        error: e.toString(),
        message: 'Payment failed: $e',
      );
    }
  }

  /// Validate card number using basic Luhn algorithm
  bool validateCardNumber(String cardNumber) {
    try {
      if (cardNumber.isEmpty) return false;

      // Remove spaces and non-digits
      final cleanNumber = cardNumber.replaceAll(RegExp(r'\D'), '');

      // Check length (13-19 digits for most cards)
      if (cleanNumber.length < 13 || cleanNumber.length > 19) return false;

      // Luhn algorithm
      int sum = 0;
      bool alternate = false;

      for (int i = cleanNumber.length - 1; i >= 0; i--) {
        int digit = int.parse(cleanNumber[i]);

        if (alternate) {
          digit *= 2;
          if (digit > 9) digit -= 9;
        }

        sum += digit;
        alternate = !alternate;
      }

      return sum % 10 == 0;
    } catch (e) {
      _logger.w('Error validating card number: $e');
      return false;
    }
  }

  /// Validate expiry date (MM/YY format)
  bool validateExpiryDate(String expiryDate) {
    try {
      if (expiryDate.length != 5 || !expiryDate.contains('/')) return false;

      final parts = expiryDate.split('/');
      if (parts.length != 2) return false;

      final month = int.tryParse(parts[0]);
      final year = int.tryParse(parts[1]);

      if (month == null || year == null) return false;
      if (month < 1 || month > 12) return false;

      // Convert 2-digit year to 4-digit
      final fullYear = year < 100 ? 2000 + year : year;
      final now = DateTime.now();
      final expiryDateTime = DateTime(
        fullYear,
        month + 1,
        0,
      ); // Last day of expiry month

      return expiryDateTime.isAfter(now);
    } catch (e) {
      _logger.w('Error validating expiry date: $e');
      return false;
    }
  }

  /// Validate CVC (3-4 digits)
  bool validateCVC(String cvc) {
    try {
      if (cvc.isEmpty) return false;
      final cleanCvc = cvc.replaceAll(RegExp(r'\D'), '');
      return cleanCvc.length >= 3 && cleanCvc.length <= 4;
    } catch (e) {
      _logger.w('Error validating CVC: $e');
      return false;
    }
  }

  /// Get card brand from number
  CardBrand getCardBrand(String cardNumber) {
    try {
      final cleanNumber = cardNumber.replaceAll(RegExp(r'\D'), '');
      if (cleanNumber.isEmpty) return CardBrand.Unknown;

      // Visa: starts with 4
      if (cleanNumber.startsWith('4')) return CardBrand.Visa;

      // Mastercard: starts with 5 or 2
      if (cleanNumber.startsWith('5') ||
          (cleanNumber.startsWith('2') && cleanNumber.length >= 2)) {
        return CardBrand.Mastercard;
      }
      // American Express: starts with 34 or 37
      if (cleanNumber.startsWith('34') || cleanNumber.startsWith('37')) {
        return CardBrand.Amex;
      }

      // Discover: starts with 6
      if (cleanNumber.startsWith('6')) return CardBrand.Discover;

      return CardBrand.Unknown;
    } catch (e) {
      _logger.w('Error getting card brand: $e');
      return CardBrand.Unknown;
    }
  }

  /// Format card number for display
  String formatCardNumber(String cardNumber) {
    try {
      final cleanNumber = cardNumber.replaceAll(RegExp(r'\D'), '');
      if (cleanNumber.length <= 4) return cleanNumber;

      // Format as groups of 4 digits
      String formatted = '';
      for (int i = 0; i < cleanNumber.length; i += 4) {
        if (i > 0) formatted += ' ';
        final end = (i + 4 < cleanNumber.length) ? i + 4 : cleanNumber.length;
        formatted += cleanNumber.substring(i, end);
      }

      return formatted;
    } catch (e) {
      _logger.w('Error formatting card number: $e');
      return cardNumber;
    }
  }
}
