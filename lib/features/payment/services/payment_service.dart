import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:logger/logger.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/payment/models/payment_result_model.dart';

class PaymentService {
  final ApiClient _apiClient;
  final Logger _logger = Logger();

  PaymentService({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Create a payment method using Stripe SDK
  Future<PaymentMethod> createPaymentMethod({
    required Map<String, dynamic> cardDetails,
    Map<String, dynamic>? billingDetails,
  }) async {
    try {
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails:
                billingDetails != null
                    ? BillingDetails.fromJson(billingDetails)
                    : null,
          ),
        ),
      );

      return paymentMethod;
    } catch (e) {
      _logger.e('Error creating payment method: $e');
      throw Exception('Failed to create payment method: $e');
    }
  }

  /// Process payment for an order
  Future<PaymentResult> processPayment({
    required String orderId,
    required String paymentMethodId,
    bool savePaymentMethod = false,
  }) async {
    try {
      _logger.i(
        'Processing payment for order: $orderId with payment method: $paymentMethodId',
      );

      final response = await _apiClient.post(
        '/orders/$orderId/pay',
        data: {
          'paymentMethod': 'credit_card',
          'paymentToken': paymentMethodId,
          'savePaymentMethod': savePaymentMethod,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final status = response.data['status'];

        switch (status) {
          case 'success':
            return PaymentResult(
              status: PaymentStatus.success,
              paymentId: data['paymentId'],
              orderId: orderId,
              message: 'Payment successful',
            );

          case 'requires_action':
            return PaymentResult(
              status: PaymentStatus.requiresAction,
              orderId: orderId,
              clientSecret: data['clientSecret'],
              paymentIntentId: data['paymentIntentId'],
              message: 'Additional authentication required',
            );

          default:
            throw Exception('Unknown payment status: $status');
        }
      } else {
        _logger.w('Payment failed with status: ${response.statusCode}');
        throw Exception('Payment failed: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('Error processing payment: $e');
      return PaymentResult(
        status: PaymentStatus.failed,
        orderId: orderId,
        error: e.toString(),
        message: 'Payment failed: ${e.toString()}',
      );
    }
  }

  /// Handle 3D Secure authentication
  Future<PaymentResult> handle3DSecure({
    required String clientSecret,
    required String paymentIntentId,
    required String orderId,
  }) async {
    try {
      _logger.i('Handling 3D Secure for payment intent: $paymentIntentId');

      final result = await Stripe.instance.handleNextAction(clientSecret);

      if (result.status == PaymentIntentsStatus.Succeeded) {
        return PaymentResult(
          status: PaymentStatus.success,
          paymentIntentId: paymentIntentId,
          orderId: orderId,
          message: 'Payment completed successfully',
        );
      } else if (result.status == PaymentIntentsStatus.RequiresAction) {
        return PaymentResult(
          status: PaymentStatus.requiresAction,
          paymentIntentId: paymentIntentId,
          orderId: orderId,
          clientSecret: clientSecret,
          message: 'Additional authentication required',
        );
      } else {
        throw Exception('3D Secure authentication failed: ${result.status}');
      }
    } catch (e) {
      _logger.e('Error handling 3D Secure: $e');
      return PaymentResult(
        status: PaymentStatus.failed,
        orderId: orderId,
        error: e.toString(),
        message: '3D Secure authentication failed: ${e.toString()}',
      );
    }
  }

  /// Save a payment method to the backend
  Future<Map<String, dynamic>> savePaymentMethod({
    required String paymentMethodId,
    bool setAsDefault = false,
  }) async {
    try {
      final response = await _apiClient.post(
        '/payments/methods',
        data: {
          'paymentMethodId': paymentMethodId,
          'setAsDefault': setAsDefault,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['data'];
      } else {
        throw Exception(
          'Failed to save payment method: ${response.statusCode}',
        );
      }
    } catch (e) {
      _logger.e('Error saving payment method: $e');
      throw Exception('Failed to save payment method: $e');
    }
  }

  /// Get saved payment methods
  Future<List<Map<String, dynamic>>> getSavedPaymentMethods() async {
    try {
      final response = await _apiClient.get('/payments/methods');

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception(
          'Failed to fetch payment methods: ${response.statusCode}',
        );
      }
    } catch (e) {
      _logger.e('Error fetching payment methods: $e');
      throw Exception('Failed to fetch payment methods: $e');
    }
  }

  /// Delete a saved payment method
  Future<void> deletePaymentMethod(String paymentMethodId) async {
    try {
      final response = await _apiClient.delete(
        '/payments/methods/$paymentMethodId',
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to delete payment method: ${response.statusCode}',
        );
      }
    } catch (e) {
      _logger.e('Error deleting payment method: $e');
      throw Exception('Failed to delete payment method: $e');
    }
  }

  /// Set a payment method as default
  Future<void> setDefaultPaymentMethod(String paymentMethodId) async {
    try {
      final response = await _apiClient.put(
        '/payments/methods/$paymentMethodId/default',
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to set default payment method: ${response.statusCode}',
        );
      }
    } catch (e) {
      _logger.e('Error setting default payment method: $e');
      throw Exception('Failed to set default payment method: $e');
    }
  }
}
