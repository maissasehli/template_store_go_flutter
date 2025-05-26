import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:logger/logger.dart';
import '../models/payment_result_model.dart';
import '../models/payment_method_model.dart' as models;
import '../models/payment_history_model.dart';
import '../repositories/payment_repository.dart';
import 'stripe_service.dart';

class PaymentService {
  final PaymentRepository _paymentRepository;
  final StripeService _stripeService;
  final Logger _logger = Logger();

  PaymentService({
    required PaymentRepository paymentRepository,
    required StripeService stripeService,
  }) : _paymentRepository = paymentRepository,
       _stripeService = stripeService;

  /// Initialize payment services
  Future<void> initialize(String stripePublishableKey) async {
    await _stripeService.initialize(stripePublishableKey);
  }

  /// Get payment history
  Future<List<PaymentHistory>> getPaymentHistory({
    int page = 1,
    int limit = 20,
  }) async {
    return await _paymentRepository.getPaymentHistory(page: page, limit: limit);
  }

  /// Get saved payment methods
  Future<List<models.PaymentMethod>> getSavedPaymentMethods() async {
    return await _paymentRepository.getPaymentMethods();
  }

  /// Create and save a new payment method
  Future<models.PaymentMethod> createAndSavePaymentMethod({
    required String cardNumber,
    required int expiryMonth,
    required int expiryYear,
    required String cvc,
    required String cardholderName,
    String? email,
    bool setAsDefault = false,
  }) async {
    try {
      // Create billing details
      final billingDetails = BillingDetails(name: cardholderName, email: email);

      // Create payment method with Stripe
      final stripePaymentMethod = await _stripeService.createCardPaymentMethod(
        cardNumber: cardNumber,
        expiryMonth: expiryMonth,
        expiryYear: expiryYear,
        cvc: cvc,
        billingDetails: billingDetails,
      );

      // Save to backend
      final savedPaymentMethod = await _paymentRepository.addPaymentMethod(
        paymentMethodId: stripePaymentMethod.id,
        setAsDefault: setAsDefault,
      );

      _logger.i('Payment method created and saved: ${savedPaymentMethod.id}');
      return savedPaymentMethod;
    } catch (e) {
      _logger.e('Error creating and saving payment method: $e');
      throw Exception('Failed to create payment method: $e');
    }
  }

  /// Delete a payment method
  Future<void> deletePaymentMethod(String paymentMethodId) async {
    return await _paymentRepository.deletePaymentMethod(paymentMethodId);
  }

  /// Set default payment method
  Future<models.PaymentMethod> setDefaultPaymentMethod(
    String paymentMethodId,
  ) async {
    return await _paymentRepository.setDefaultPaymentMethod(paymentMethodId);
  }

  /// Process payment for an order
  Future<PaymentResult> processPayment({
    required String orderId,
    required double amount,
    required String currency,
    String? paymentMethodId,
    bool savePaymentMethod = false,
    Map<String, dynamic>? metadata,
  }) async {
    return await _paymentRepository.processPayment(
      orderId: orderId,
      amount: amount,
      currency: currency,
      paymentMethodId: paymentMethodId,
      savePaymentMethod: savePaymentMethod,
      metadata: metadata,
    );
  }

  /// Handle 3D Secure authentication
  Future<PaymentResult> handle3DSecure({required String clientSecret}) async {
    return await _stripeService.handleNextAction(
      paymentIntentClientSecret: clientSecret,
    );
  }

  /// Confirm payment with Stripe
  Future<PaymentResult> confirmPayment({
    required String paymentIntentClientSecret,
    PaymentMethodParams? paymentMethodParams,
  }) async {
    return await _stripeService.confirmPayment(
      paymentIntentClientSecret: paymentIntentClientSecret,
      paymentMethodParams: paymentMethodParams,
    );
  }

  /// Present Stripe payment sheet
  Future<PaymentResult> presentPaymentSheet({
    required String paymentIntentClientSecret,
    String? ephemeralKeySecret,
    String? customerId,
    String? merchantDisplayName,
  }) async {
    return await _stripeService.presentPaymentSheet(
      paymentIntentClientSecret: paymentIntentClientSecret,
      ephemeralKeySecret: ephemeralKeySecret,
      customerId: customerId,
      merchantDisplayName: merchantDisplayName,
    );
  }

  /// Validate card details
  bool validateCardNumber(String cardNumber) {
    return _stripeService.validateCardNumber(cardNumber);
  }

  bool validateExpiryDate(String expiryDate) {
    return _stripeService.validateExpiryDate(expiryDate);
  }

  bool validateCVC(String cvc) {
    return _stripeService.validateCVC(cvc);
  }

  /// Get card brand
  CardBrand getCardBrand(String cardNumber) {
    return _stripeService.getCardBrand(cardNumber);
  }

  /// Format card number for display
  String formatCardNumber(String cardNumber) {
    return _stripeService.formatCardNumber(cardNumber);
  }
}
