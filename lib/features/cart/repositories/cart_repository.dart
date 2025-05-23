import 'package:get/get.dart';
import 'package:store_go/app/core/services/api_client.dart';
import '../models/cart_model.dart';

class CartRepository {
  final ApiClient _apiService = Get.find<ApiClient>();

  // Get cart (matches Bruno: GET /cart)
  Future<Map<String, dynamic>?> getCart() async {
    try {
      final response = await _apiService.get('/cart');
      final data = response.data;

      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return data['data'];
      }
      return data;
    } catch (e) {
      throw Exception('Failed to fetch cart: ${e.toString()}');
    }
  }

  // Get cart items (for backward compatibility)
  Future<List<CartItem>> getCartItems() async {
    try {
      final cartData = await getCart();
      if (cartData != null) {
        final items = cartData['items'] as List? ?? [];
        return items.map((item) => CartItem.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch cart items: ${e.toString()}');
    }
  }

  // Add to cart (matches Bruno: POST /products/cart/:productId)
  Future<void> addToCart({
    required String productId,
    int quantity = 1,
    Map<String, dynamic>? variants,
  }) async {
    try {
      final data = <String, dynamic>{'quantity': quantity};

      if (variants != null && variants.isNotEmpty) {
        data['variants'] = variants;
      }

      await _apiService.post('/products/cart/$productId', data: data);
    } catch (e) {
      throw Exception('Failed to add to cart: ${e.toString()}');
    }
  }

  // Add cart item (alternative method)
  Future<void> addCartItem(CartItem item) async {
    try {
      final variants =
          item.variantId.isNotEmpty ? {'variantId': item.variantId} : null;

      await addToCart(
        productId: item.productId,
        quantity: item.quantity,
        variants: variants,
      );
    } catch (e) {
      throw Exception('Failed to add cart item: ${e.toString()}');
    }
  }

  // Update cart item (matches Bruno: PUT /cart/items/:cartItemId)
  Future<void> updateCartItem({
    required String cartItemId,
    int? quantity,
    Map<String, dynamic>? variants,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (quantity != null) {
        data['quantity'] = quantity;
      }

      if (variants != null) {
        data['variants'] = variants;
      }

      if (data.isEmpty) {
        throw Exception(
          'At least one field (quantity or variants) must be provided',
        );
      }

      await _apiService.put('/cart/items/$cartItemId', data: data);
    } catch (e) {
      throw Exception('Failed to update cart item: ${e.toString()}');
    }
  }

  // Update cart item with CartItem object
  Future<void> updateItem(CartItem item) async {
    try {
      await updateCartItem(cartItemId: item.id, quantity: item.quantity);
    } catch (e) {
      throw Exception('Failed to update item: ${e.toString()}');
    }
  }

  // Remove from cart (matches Bruno: DELETE /cart/items/:cartItemId)
  Future<void> removeFromCart(String cartItemId) async {
    try {
      await _apiService.delete('/cart/items/$cartItemId');
    } catch (e) {
      throw Exception('Failed to remove from cart: ${e.toString()}');
    }
  }

  // Clear cart (matches Bruno: DELETE /cart)
  Future<void> clearCart() async {
    try {
      await _apiService.delete('/cart');
    } catch (e) {
      throw Exception('Failed to clear cart: ${e.toString()}');
    }
  }

  // Get cart summary (matches Bruno: GET /cart/summary)
  Future<Map<String, dynamic>?> getCartSummary() async {
    try {
      final response = await _apiService.get('/cart/summary');
      final data = response.data;

      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return data['data'];
      }
      return data;
    } catch (e) {
      throw Exception('Failed to get cart summary: ${e.toString()}');
    }
  }

  // Get cart item by ID (matches Bruno: GET /cart/items/:cartItemId)
  Future<Map<String, dynamic>?> getCartItemById(String cartItemId) async {
    try {
      final response = await _apiService.get('/cart/items/$cartItemId');
      final data = response.data;

      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return data['data'];
      }
      return data;
    } catch (e) {
      throw Exception('Failed to get cart item: ${e.toString()}');
    }
  }

  // Validate cart (matches Bruno: POST /cart/validate)
  Future<Map<String, dynamic>?> validateCart() async {
    try {
      final response = await _apiService.post('/cart/validate');
      final data = response.data;

      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return data['data'];
      }
      return data;
    } catch (e) {
      throw Exception('Failed to validate cart: ${e.toString()}');
    }
  }

  // Check cart promotions (matches Bruno: POST /cart/check-promotions)
  Future<Map<String, dynamic>?> checkCartPromotions(
    List<Map<String, dynamic>> cartItems,
  ) async {
    try {
      final response = await _apiService.post(
        '/cart/check-promotions',
        data: {'cartItems': cartItems},
      );
      final data = response.data;

      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return data['data'];
      }
      return data;
    } catch (e) {
      throw Exception('Failed to check promotions: ${e.toString()}');
    }
  }

  // Apply coupon (placeholder - implement based on your API)
  Future<double> applyCoupon(String couponCode) async {
    try {
      // This is a placeholder implementation
      // Replace with actual API call when available
      if (couponCode.toLowerCase() == 'save10') {
        return 10.0; // $10 discount
      }
      return 0.0;
    } catch (e) {
      throw Exception('Failed to apply coupon: ${e.toString()}');
    }
  }
}
