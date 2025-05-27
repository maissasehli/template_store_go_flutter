import 'package:logger/logger.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/order/model/order_model.dart';

class OrderRepository {
  final ApiClient _apiClient;
  final Logger _logger = Logger();

  OrderRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Create a new order from cart items
  Future<String> createOrder(OrderRequest orderRequest) async {
    try {
      final requestData = orderRequest.toJson();
      _logger.i('Creating order with data: ${requestData}');

      final response = await _apiClient.post('/orders', data: requestData);

      _logger.i(
        'Order creation response: ${response.statusCode} - ${response.data}',
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return data['orderId'];
      } else {
        _logger.w('Failed to create order: ${response.statusCode}');
        throw Exception('Failed to create order: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('Error creating order: $e');
      throw Exception('Failed to create order: $e');
    }
  }

  /// Get all orders for the authenticated user with optional status filter
  Future<List<OrderModel>> getOrders({String? status}) async {
    try {
      String endpoint = '/orders';
      // Only add status filter if it's not 'All' and not empty
      if (status != null &&
          status.isNotEmpty &&
          status.toLowerCase() != 'all') {
        endpoint += '?status=${status.toLowerCase()}';
      }

      final response = await _apiClient.get(endpoint);

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((item) => OrderModel.fromJson(item)).toList();
      } else {
        _logger.w('Failed to fetch orders: ${response.statusCode}');
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('Error fetching orders: $e');
      throw Exception('Failed to load orders: $e');
    }
  }

  /// Get all orders for the authenticated user (alternative method name)
  Future<List<OrderModel>> getUserOrders() async {
    return await getOrders();
  }

  /// Get detailed information about a specific order
  Future<OrderModel?> getOrderDetails(String orderId) async {
    try {
      final response = await _apiClient.get('/orders/$orderId');

      if (response.statusCode == 200) {
        return OrderModel.fromJson(response.data['data']);
      } else {
        _logger.w('Failed to fetch order details: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      _logger.e('Error fetching order details: $e');
      return null;
    }
  }

  /// Cancel an order
  Future<bool> cancelOrder(String orderId) async {
    try {
      final response = await _apiClient.put(
        '/orders/$orderId',
        data: {'status': 'cancelled'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        _logger.w('Failed to cancel order: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      _logger.e('Error cancelling order: $e');
      return false;
    }
  }

  /// Process payment for an order
  Future<Map<String, dynamic>> processOrderPayment(
    String orderId,
    String paymentToken,
    String paymentMethod, {
    bool savePaymentMethod = false,
  }) async {
    try {
      final response = await _apiClient.post(
        '/orders/$orderId/pay',
        data: {
          'paymentMethod': paymentMethod,
          'paymentToken': paymentToken,
          'savePaymentMethod': savePaymentMethod,
        },
      );

      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        _logger.w('Failed to process payment: ${response.statusCode}');
        throw Exception('Failed to process payment: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('Error processing payment: $e');
      throw Exception('Failed to process payment: $e');
    }
  }
}
