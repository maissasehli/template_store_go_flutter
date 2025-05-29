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
        '/payments',
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
      final response = await _apiClient.get('/payments/methods');

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
    String type = 'credit_card',
    String? cardholderName,
  }) async {
    try {
      // Create request data according to API documentation
      final data = {
        'type': type,
        'stripePaymentMethodId':
            paymentMethodId, // Correct field name per API docs
        'isDefault': setAsDefault,
        if (cardholderName != null)
          'details': {'cardholderName': cardholderName},
      };

      _logger.i('Adding payment method with data: $data');
      _logger.i('POST /payments/methods');

      final response = await _apiClient.post('/payments/methods', data: data);

      _logger.i('Add payment method response status: ${response.statusCode}');
      _logger.i('Add payment method response body: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final paymentMethod = PaymentMethod.fromJson(response.data['data']);
        _logger.i('Successfully created payment method: ${paymentMethod.id}');
        return paymentMethod;
      } else {
        _logger.w('Failed to add payment method: ${response.statusCode}');
        _logger.w('Response data: ${response.data}');
        throw Exception('Failed to add payment method: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('Error adding payment method: $e');
      if (e.toString().contains('400')) {
        _logger.e('400 Bad Request - Check request format and required fields');
        _logger.e(
          'Expected fields: type, stripePaymentMethodId, isDefault, details{cardholderName}',
        );
      }
      throw Exception('Failed to add payment method: $e');
    }
  }

  /// Delete a payment method
  Future<void> deletePaymentMethod(String paymentMethodId) async {
    try {
      final response = await _apiClient.delete(
        '/payments/methods/$paymentMethodId',
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
        '/payments/methods/$paymentMethodId/default',
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

      _logger.i('Processing payment request:');
      _logger.i('- URL: /orders/$orderId/pay');
      _logger.i('- Request data: ${paymentRequest.toJson()}');

      final response = await _apiClient.post(
        '/orders/$orderId/pay',
        data: paymentRequest.toJson(),
      );
      _logger.i('Payment response status: ${response.statusCode}');
      _logger.i('Payment response data: ${response.data}');

      // Add detailed logging of the response structure
      if (response.data is Map<String, dynamic>) {
        final responseData = response.data as Map<String, dynamic>;
        _logger.i('Root status: ${responseData['status']}');
        _logger.i('Root message: ${responseData['message']}');
        if (responseData['data'] != null) {
          _logger.i('Nested data: ${responseData['data']}');
        }
      }
      if (response.statusCode == 200) {
        final responseData = response.data;
        final rootStatus = responseData['status'] as String;

        // For success responses, check the payment status in the nested data object
        if (rootStatus.toLowerCase() == 'success') {
          final paymentData = responseData['data'] as Map<String, dynamic>;
          final paymentStatus = paymentData['status'] as String;
          switch (paymentStatus.toLowerCase()) {
            case 'succeeded':
            case 'paid': // Add support for 'paid' status from server
              return PaymentResult.success(
                paymentId: paymentData['paymentId'] as String?,
                orderId: orderId,
                paymentIntentId: paymentData['paymentIntentId'] as String?,
                message:
                    responseData['message'] as String? ?? 'Payment successful',
              );
            case 'processing':
              return PaymentResult.processing(
                orderId: orderId,
                message:
                    responseData['message'] as String? ?? 'Payment processing',
              );
            default:
              return PaymentResult.failed(
                orderId: orderId,
                error: paymentData['error'] as String?,
                message: responseData['message'] as String? ?? 'Payment failed',
              );
          }
        }
        // For requires_action responses
        else if (rootStatus.toLowerCase() == 'requires_action') {
          final paymentData = responseData['data'] as Map<String, dynamic>;
          return PaymentResult.requiresAction(
            clientSecret: paymentData['clientSecret'] as String,
            paymentIntentId: paymentData['paymentIntentId'] as String?,
            orderId: orderId,
            message:
                responseData['message'] as String? ??
                'Additional authentication required',
          );
        }
        // For error responses
        else {
          return PaymentResult.failed(
            orderId: orderId,
            error:
                responseData['errors']?.toString(),
            message: responseData['message'] as String? ?? 'Payment failed',
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
