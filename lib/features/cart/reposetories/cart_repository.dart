import 'package:logger/logger.dart';
import 'package:store_go/app/core/config/app_config.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/cart/models/cart_model.dart';

class CartRepository {
  final ApiClient _apiClient;
  final Logger _logger = Logger();

  CartRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<CartItem>> getCartItems() async {
    try {
      final fullUrl = '${AppConfig.baseUrl}/products/cart';
      _logger.i('Fetching cart items from: $fullUrl');
      final response = await _apiClient.get('/products/cart');

      if (response.statusCode == 200) {
        final data = response.data['data'] as List? ?? [];
        return data.map((item) => CartItem.fromJson(item as Map<String, dynamic>)).toList();
      } else if (response.statusCode == 405) {
        _logger.w('Method not allowed for $fullUrl (status: 405)');
        throw Exception('Server does not allow GET request for cart. Check server routes.');
      } else {
        _logger.w('Cart endpoint returned ${response.statusCode}');
        throw Exception('Failed to load cart items: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('Error fetching cart items: $e');
      throw Exception('Failed to load cart items: $e');
    }
  }

  Future<void> addToCart(CartItem item) async {
    try {
      final fullUrl = '${AppConfig.baseUrl}/products/cart/${item.productId}';
      _logger.i('Adding to cart at: $fullUrl');
      await _apiClient.post('/products/cart/${item.productId}', data: {
        'quantity': item.quantity,
        'variants': item.variants,
      });
    } catch (e) {
      _logger.e('Failed to add item to cart: $e');
      throw Exception('Failed to add item to cart: $e');
    }
  }

  Future<void> removeFromCart(String productId) async {
    try {
      final fullUrl = '${AppConfig.baseUrl}/products/cart/$productId';
      _logger.i('Removing from cart at: $fullUrl');
      await _apiClient.delete('/products/cart/$productId');
    } catch (e) {
      _logger.e('Failed to remove item from cart: $e');
      throw Exception('Failed to remove item from cart: $e');
    }
  }

  Future<void> updateCartItem(CartItem item) async {
    try {
      final fullUrl = '${AppConfig.baseUrl}/products/cart/${item.productId}';
      _logger.i('Updating cart item at: $fullUrl');
      final data = {
        'quantity': item.quantity,
      };
      if (item.variants.isNotEmpty) {
        data['variants'] = item.variants as int;
      }
      await _apiClient.put('/products/cart/${item.productId}', data: data);
    } catch (e) {
      _logger.e('Failed to update item in cart: $e');
      throw Exception('Failed to update item in cart: $e');
    }
  }

  Future<void> clearCart() async {
    try {
      final fullUrl = '${AppConfig.baseUrl}/products/cart';
      _logger.i('Clearing cart at: $fullUrl');
      await _apiClient.delete('/products/cart');
    } catch (e) {
      _logger.e('Failed to clear cart: $e');
      throw Exception('Failed to clear cart: $e');
    }
  }

  Future<double> applyCoupon(String couponCode) async {
    try {
      final fullUrl = '${AppConfig.baseUrl}/products/cart/coupon';
      _logger.i('Applying coupon at: $fullUrl');
      final response = await _apiClient.post('/products/cart/coupon', data: {'code': couponCode});
      if (response.statusCode == 200) {
        return (response.data['data']['discount'] ?? 0.0).toDouble();
      }
      throw Exception('Failed to apply coupon: ${response.statusCode}');
    } catch (e) {
      _logger.e('Failed to apply coupon: $e');
      throw Exception('Failed to apply coupon: $e');
    }
  }
}