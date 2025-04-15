import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/order/model/order_model.dart';

// Updated OrderRepository with better error handling
class OrderRepository {
  final ApiClient _apiClient;

  OrderRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<OrderModel>> getOrders({String? status}) async {
    try {
      final queryParams = status != null ? {'status': status} : null;
      final response = await _apiClient.get('/orders', queryParameters: queryParams);

      // Check for 500 error
      if (response.statusCode == 500) {
        print('Server returned 500 error for orders');
        return []; // Return empty list instead of throwing
      }

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((item) => OrderModel.fromJson(item)).toList();
      } else {
        print('Unexpected status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error in getOrders: $e');
      return []; // Return empty list on error
    }
  }

  Future<OrderModel?> getOrderDetails(String orderId) async {
    try {
      final response = await _apiClient.get('/orders/$orderId');

      // Check for 500 error
      if (response.statusCode == 500) {
        print('Server returned 500 error for order details');
        return null;
      }

      if (response.statusCode == 200) {
        return OrderModel.fromJson(response.data['data']);
      } else {
        print('Unexpected status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error in getOrderDetails: $e');
      return null;
    }
  }

  Future<bool> cancelOrder(String orderId) async {
    try {
      final response = await _apiClient.post('/orders/$orderId/cancel');
      
      // Check for 500 error
      if (response.statusCode == 500) {
        print('Server returned 500 error when cancelling order');
        return false;
      }
      
      return response.statusCode == 200;
    } catch (e) {
      print('Error in cancelOrder: $e');
      return false;
    }
  }
}