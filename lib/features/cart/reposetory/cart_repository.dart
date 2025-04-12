import 'package:dio/dio.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/cart/models/cart_model.dart';

class CartRepository {
  final ApiClient _apiClient;
  final Logger _logger = Logger();

  CartRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<CartItem>> getCartItems() async {
    try {
      final response = await _apiClient.get('/cart');
      
      if (response.statusCode == 200) {
        final data = response.data['items'] as List? ?? [];
        return data.map((item) => CartItem.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        _logger.w('Cart endpoint returned ${response.statusCode}, using empty cart');
        return [];
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        _logger.w('Cart endpoint not found (404), using empty cart');
        return [];
      }
      _logger.e('Error fetching cart items: $e');
      return [];
    } catch (e) {
      _logger.e('Unexpected error fetching cart items: $e');
      return [];
    }
  }

  Future<void> addToCart(CartItem item) async {
    try {
      await _apiClient.post('/cart', data: item.toJson());
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        _logger.w('Cart endpoint not found (404), item will be local only');
        return;
      }
      _logger.e('Error adding item to cart: $e');
      rethrow;
    } catch (e) {
      _logger.e('Unexpected error adding item to cart: $e');
      rethrow;
    }
  }


 Future<void> removeFromCart(String itemId) async {
    try {
      // First try DELETE (REST standard)
      try {
        final response = await _apiClient.delete('/cart/$itemId');
        if (response.statusCode == 200) return;
      } on DioException catch (e) {
        if (e.response?.statusCode == 405) {
          _logger.w('DELETE not allowed, trying POST alternative');
          // Fallback to POST with action parameter
          final postResponse = await _apiClient.post(
            '/cart/remove',
            data: {'itemId': itemId},
          );
          if (postResponse.statusCode == 200) return;
        }
        rethrow;
      }

      throw Exception('Failed to remove item from cart');
    } on DioException catch (e) {
      if (e.response?.statusCode == 405) {
        _logger.w('Remove operation not supported, keeping local change');
        return;
      }
      _logger.e('Error removing item from cart: $e');
      rethrow;
    } catch (e) {
      _logger.e('Unexpected error removing item from cart: $e');
      rethrow;
    }
  }

  Future<void> updateCartItem(CartItem item) async {
    try {
      // First try PUT (REST standard)
      try {
        final response = await _apiClient.put('/cart/${item.id}', data: item.toJson());
        if (response.statusCode == 200) return;
      } on DioException catch (e) {
        if (e.response?.statusCode == 405) {
          _logger.w('PUT not allowed, trying POST alternative');
          // Fallback to POST with action parameter
          final postResponse = await _apiClient.post(
            '/cart/update',
            data: item.toJson(),
          );
          if (postResponse.statusCode == 200) return;
        }
        rethrow;
      }

      throw Exception('Failed to update cart item');
    } on DioException catch (e) {
      if (e.response?.statusCode == 405) {
        _logger.w('Update operation not supported, keeping local change');
        return;
      }
      _logger.e('Error updating cart item: $e');
      rethrow;
    } catch (e) {
      _logger.e('Unexpected error updating cart item: $e');
      rethrow;
    }
  }


  Future<void> clearCart() async {
    try {
      final response = await _apiClient.delete('/cart');
      
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to clear cart: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _logger.e('Error clearing cart: $e');
      
      // If the endpoint doesn't exist, log it but don't throw
      if (e.response?.statusCode == 404) {
        _logger.w('Cart clear endpoint not found, changes will only exist locally');
        return; // Just return without throwing
      }
      
      throw Exception('Failed to clear cart: $e');
    } catch (e) {
      _logger.e('Error clearing cart: $e');
      throw Exception('Failed to clear cart: $e');
    }
  }

  Future<double> applyCoupon(String couponCode) async {
    try {
      final response = await _apiClient.post('/cart/coupon', data: {'code': couponCode});
      
      if (response.statusCode != 200) {
        throw Exception('Failed to apply coupon: ${response.statusCode}');
      }
      
      // Return the discount amount from the server response
      return (response.data['discount'] ?? 0.0).toDouble();
    } on DioException catch (e) {
      _logger.e('Error applying coupon: $e');
      
      // If the endpoint doesn't exist, log it but don't throw
      if (e.response?.statusCode == 404) {
        _logger.w('Coupon endpoint not found, no discount will be applied');
        return 0.0; // Return zero discount
      }
      
      throw Exception('Failed to apply coupon: $e');
    } catch (e) {
      _logger.e('Error applying coupon: $e');
      throw Exception('Failed to apply coupon: $e');
    }
  }
  
}