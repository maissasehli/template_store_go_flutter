import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/order/model/order_model.dart';

class OrderRepository {
  final ApiClient _apiClient;

  OrderRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<OrderModel>> getOrders({String? status}) async {
    try {
      final queryParams = status != null ? {'status': status} : null;
      final response = await _apiClient.get('/orders', queryParameters: queryParams);

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((item) => OrderModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      throw Exception('Failed to load orders: $e');
    }
  }

  Future<OrderModel> getOrderDetails(String orderId) async {
    try {
      final response = await _apiClient.get('/orders/$orderId');

      if (response.statusCode == 200) {
        return OrderModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to load order details');
      }
    } catch (e) {
      throw Exception('Failed to load order details: $e');
    }
  }

  // For future implementation: cancel order, track order, etc.
  Future<void> cancelOrder(String orderId) async {
    try {
      await _apiClient.post('/orders/$orderId/cancel');
    } catch (e) {
      throw Exception('Failed to cancel order: $e');
    }
  }
}