import 'package:logger/logger.dart';
import 'package:store_go/app/core/services/api_client.dart';
import '../models/payment_method_model.dart';
import '../models/payment_history_model.dart';
import '../models/payment_request_model.dart';
import '../models/payment_result_model.dart';

class PaymentRepository {
  final ApiClient _apiClient;
  final Logger _logger = Logger();

  PaymentRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Fetch payment history for the authenticated user
  Future<List<PaymentHistory>> getPaymentHistory({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        '/api/mobile-app/payments',
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((item) => PaymentHistory.fromJson(item)).toList();
      } else {
        _logger.w('Failed to fetch payment history: ${response.statusCode}');
        throw Exception(
          'Failed to load payment history: ${response.statusCode}',
        );
      }
    } catch (e) {
      _logger.e('Error fetching payment history: $e');
      throw Exception('Failed to load payment history: $e');
    }
  }

  /// Fetch all saved payment methods for the authenticated user
  Future<List<PaymentMethod>> getPaymentMethods() async {
    try {
      final response = await _apiClient.get('/api/mobile-app/payments/methods');

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((item) => PaymentMethod.fromJson(item)).toList();
      } else {
        _logger.w('Failed to fetch payment methods: ${response.statusCode}');
        throw Exception(
          'Failed to load payment methods: ${response.statusCode}',
        );
      }
    } catch (e) {
      _logger.e('Error fetching payment methods: $e');
      throw Exception('Failed to load payment methods: $e');
    }
  }

  /// Add a new payment method
  Future<PaymentMethod> addPaymentMethod({
    required String paymentMethodId,
    bool setAsDefault = false,
  }) async {
    try {
      final data = {
        'payment_method_id': paymentMethodId,
        'set_as_default': setAsDefault,
      };

      final response = await _apiClient.post(
        '/api/mobile-app/payments/methods',
        data: data,
      );

      if (response.statusCode == 201) {
        return PaymentMethod.fromJson(response.data['data']);
      } else {
        _logger.w('Failed to add payment method: ${response.statusCode}');
        throw Exception('Failed to add payment method: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('Error adding payment method: $e');
      throw Exception('Failed to add payment method: $e');
    }
  }

  /// Delete a payment method
  Future<void> deletePaymentMethod(String paymentMethodId) async {
    try {
      final response = await _apiClient.delete(
        '/api/mobile-app/payments/methods/$paymentMethodId',
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        _logger.w('Failed to delete payment method: ${response.statusCode}');
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
  Future<PaymentMethod> setDefaultPaymentMethod(String paymentMethodId) async {
    try {
      final response = await _apiClient.put(
        '/api/mobile-app/payments/methods/$paymentMethodId/default',
      );

      if (response.statusCode == 200) {
        return PaymentMethod.fromJson(response.data['data']);
      } else {
        _logger.w(
          'Failed to set default payment method: ${response.statusCode}',
        );
        throw Exception(
          'Failed to set default payment method: ${response.statusCode}',
        );
      }
    } catch (e) {
      _logger.e('Error setting default payment method: $e');
      throw Exception('Failed to set default payment method: $e');
    }
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
    try {
      final paymentRequest = PaymentRequest(
        orderId: orderId,
        amount: amount,
        currency: currency,
        paymentMethodId: paymentMethodId,
        savePaymentMethod: savePaymentMethod,
        metadata: metadata,
      );

      final response = await _apiClient.post(
        '/api/mobile-app/orders/$orderId/pay',
        data: paymentRequest.toJson(),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final status = data['status'] as String;

        switch (status.toLowerCase()) {
          case 'succeeded':
            return PaymentResult.success(
              paymentId: data['payment_id'] as String?,
              orderId: orderId,
              paymentIntentId: data['payment_intent_id'] as String?,
              message: data['message'] as String? ?? 'Payment successful',
            );
          case 'requires_action':
            return PaymentResult.requiresAction(
              clientSecret: data['client_secret'] as String,
              paymentIntentId: data['payment_intent_id'] as String?,
              orderId: orderId,
              message:
                  data['message'] as String? ??
                  'Additional authentication required',
            );
          case 'processing':
            return PaymentResult.processing(
              orderId: orderId,
              message: data['message'] as String? ?? 'Payment processing',
            );
          default:
            return PaymentResult.failed(
              orderId: orderId,
              error: data['error'] as String?,
              message: data['message'] as String? ?? 'Payment failed',
            );
        }
      } else {
        _logger.w('Failed to process payment: ${response.statusCode}');
        return PaymentResult.failed(
          orderId: orderId,
          error: 'HTTP ${response.statusCode}',
          message: 'Payment failed with status ${response.statusCode}',
        );
      }
    } catch (e) {
      _logger.e('Error processing payment: $e');
      return PaymentResult.failed(
        orderId: orderId,
        error: e.toString(),
        message: 'Payment failed: $e',
      );
    }
  }
}
