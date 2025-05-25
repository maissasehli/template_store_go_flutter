import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/checkout/models/order_request_model.dart';

class OrderRepository {
  final ApiClient _apiClient = ApiClient();

  Future<OrderResponse> createOrder(OrderRequest request) async {
    try {
      final response = await _apiClient.post('/orders', data: request.toJson());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data['data'];
        return OrderResponse.fromJson(responseData);
      } else {
        throw Exception('Failed to create order: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  Future<bool> cancelOrder(String orderId) async {
    try {
      final response = await _apiClient.put(
        '/orders/$orderId/cancel',
        data: {},
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to cancel order: $e');
    }
  }
}
