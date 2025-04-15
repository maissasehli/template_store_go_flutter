import 'package:store_go/app/core/services/api_client.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/cart/models/cart_model.dart';

class CartRepository {
  final ApiClient _apiClient;
  final Logger _logger = Logger();

  CartRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<CartItem>> getCartItems() async {
    try {
      final response = await _apiClient.get('/products/cart');
      
      if (response.statusCode == 200) {
        final data = response.data['items'] as List? ?? [];
        return data.map((item) => CartItem.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        _logger.w('Cart endpoint returned ${response.statusCode}, using empty cart');
        return [];
      }
    } catch (e) {
      _logger.e('Error fetching cart items: $e');
      return []; // Return empty list instead of throwing to maintain offline support
    }
  }

  Future<void> addToCart(CartItem item) async {
    try {
      await _apiClient.post('/products/cart/${item.productId}', data: {
        'quantity': item.quantity,
        'variants': item.variants,
      });
    } catch (e) {
      _logger.e('Failed to add item to cart: $e');
      // Don't throw - let the controller handle this gracefully
    }
  }

  Future<void> removeFromCart(String productId) async {
    try {
      await _apiClient.delete('/products/cart/$productId');
    } catch (e) {
      _logger.e('Failed to remove item from cart: $e');
      // Don't throw - let the controller handle this gracefully
    }
  }

  Future<void> updateCartItem(CartItem item) async {
    try {
      final data = {
        'quantity': item.quantity,
      };
      
      if (item.variants.isNotEmpty) {
        data['variants'] = item.variants as int;
      }
      
      await _apiClient.put('/products/cart/${item.productId}', data: data);
    } catch (e) {
      _logger.e('Failed to update item in cart: $e');
      // Don'at throw - let the controller handle this gracefully
    }
  }

  Future<void> clearCart() async {
    try {
      await _apiClient.delete('/products/cart');
    } catch (e) {
      _logger.e('Failed to clear cart: $e');
      // Don't throw - let the controller handle this gracefully
    }
  }

  Future<double> applyCoupon(String couponCode) async {
    try {
      final response = await _apiClient.post('/products/cart/coupon', data: {'code': couponCode});
      
      if (response.statusCode == 200) {
        return (response.data['discount'] ?? 0.0).toDouble();
      }
      return 0.0;
    } catch (e) {
      _logger.e('Failed to apply coupon: $e');
      return 0.0; // Return zero discount instead of throwing
    }
  }
}