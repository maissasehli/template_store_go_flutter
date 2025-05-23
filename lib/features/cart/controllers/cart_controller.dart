import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/cart/models/cart_model.dart';
import 'package:store_go/features/cart/repositories/cart_repository.dart';
import 'package:store_go/features/product/models/product_model.dart';

class CartController extends GetxController {
  final CartRepository _repository;
  final Logger _logger = Logger();

  // Observable variables
  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString couponCode = ''.obs;
  final RxString cartId = ''.obs;

  // Cart totals (matching UI expectations)
  final RxDouble subtotal = 0.0.obs;
  final RxDouble shipping = 10.0.obs; // Default shipping cost
  final RxDouble tax = 0.0.obs;
  final RxDouble discount = 0.0.obs;
  final RxDouble total = 0.0.obs;
  final RxInt totalItems = 0.obs;

  // Alternative naming for backward compatibility
  double get shippingCost => shipping.value;
  double get totalAmount => total.value;

  CartController({required CartRepository repository})
    : _repository = repository;

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  // Unified fetch method (matches Bruno: GET /cart)
  Future<void> fetchCartItems() async {
    await fetchCart();
  }

  Future<void> fetchCart() async {
    try {
      isLoading.value = true;
      isError.value = false;
      errorMessage.value = '';

      final cartData = await _repository.getCart();

      if (cartData != null) {
        cartId.value = cartData['cartId'] ?? '';

        // Parse cart items
        final items = cartData['items'] as List? ?? [];
        cartItems.value = items.map((item) => CartItem.fromJson(item)).toList();

        // Parse summary or calculate locally
        final summary = cartData['summary'] as Map<String, dynamic>?;
        if (summary != null) {
          totalItems.value = summary['totalItems'] ?? cartItems.length;
          subtotal.value = (summary['subtotal'] ?? 0.0).toDouble();
          tax.value = (summary['tax'] ?? 0.0).toDouble();
          shipping.value = (summary['shippingCost'] ?? 10.0).toDouble();
          discount.value = (summary['discount'] ?? 0.0).toDouble();
          total.value = (summary['totalAmount'] ?? 0.0).toDouble();
        } else {
          // Calculate totals locally if not provided by API
          _calculateCartTotals();
        }
      } else {
        // Empty cart
        _clearCartState();
      }
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString();
      _logger.e('Error fetching cart: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Add to cart with Product model (backward compatibility)
  Future<void> addToCart(
    Product product, {
    int quantity = 1,
    Map<String, dynamic>? variants,
  }) async {
    try {
      isUpdating.value = true;

      await _repository.addToCart(
        productId: product.id,
        quantity: quantity,
        variants: variants,
      );

      // Refresh cart to get updated data
      await fetchCart();

      Get.snackbar(
        'Success',
        '${product.name} added to cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add item to cart: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  // Add to cart with Product model (alternative naming)
  Future<void> addProductToCart({
    required Product product,
    required int quantity,
    required String variantId,
  }) async {
    try {
      isUpdating.value = true;

      final variants = variantId.isNotEmpty ? {'variantId': variantId} : null;

      await _repository.addToCart(
        productId: product.id,
        quantity: quantity,
        variants: variants,
      );

      // Refresh cart to get updated data
      await fetchCart();

      Get.snackbar(
        'Success',
        '${product.name} added to cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      _logger.e('Error adding product to cart: $e');
      Get.snackbar(
        'Error',
        'Failed to add item to cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  // Update cart item quantity (matches Bruno: PUT /cart/items/:cartItemId)
  Future<void> updateCartItem(
    String cartItemId, {
    int? quantity,
    Map<String, dynamic>? variants,
  }) async {
    try {
      isUpdating.value = true;

      await _repository.updateCartItem(
        cartItemId: cartItemId,
        quantity: quantity,
        variants: variants,
      );

      // Refresh cart to get updated data
      await fetchCart();
    } catch (e) {
      _logger.e('Error updating cart item: $e');
      Get.snackbar(
        'Error',
        'Failed to update cart item',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  // Update quantity by product ID (for UI compatibility)
  Future<void> updateQuantity(String productId, int quantity) async {
    try {
      if (quantity <= 0) {
        await removeFromCart(productId);
        return;
      }

      // Find cart item by product ID
      final cartItem = cartItems.firstWhereOrNull(
        (item) => item.productId == productId,
      );
      if (cartItem != null) {
        await updateCartItem(cartItem.id, quantity: quantity);
      }
    } catch (e) {
      _logger.e('Error updating quantity: $e');
    }
  }

  // Remove from cart by cart item ID (matches Bruno: DELETE /cart/items/:cartItemId)
  Future<void> removeCartItem(String cartItemId) async {
    try {
      isUpdating.value = true;

      await _repository.removeFromCart(cartItemId);

      // Refresh cart to get updated data
      await fetchCart();

      Get.snackbar(
        'Success',
        'Item removed from cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      _logger.e('Error removing cart item: $e');
      Get.snackbar(
        'Error',
        'Failed to remove item',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  // Remove from cart by product ID (for UI compatibility)
  Future<void> removeFromCart(String productId) async {
    try {
      // Find cart item by product ID
      final cartItem = cartItems.firstWhereOrNull(
        (item) => item.productId == productId,
      );
      if (cartItem != null) {
        await removeCartItem(cartItem.id);
      }
    } catch (e) {
      _logger.e('Error removing from cart: $e');
    }
  }

  // Clear entire cart (matches Bruno: DELETE /cart)
  Future<void> clearCart() async {
    try {
      isUpdating.value = true;

      await _repository.clearCart();

      // Clear local state
      _clearCartState();

      Get.snackbar(
        'Success',
        'Cart cleared successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      _logger.e('Error clearing cart: $e');
      Get.snackbar(
        'Error',
        'Failed to clear cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  // Apply coupon
  Future<void> applyCoupon(String code) async {
    if (code.isEmpty) {
      couponCode.value = '';
      discount.value = 0.0;
      _calculateCartTotals();
      return;
    }

    try {
      isUpdating.value = true;

      // For now, just set the coupon code
      // You can implement actual coupon validation via API later
      couponCode.value = code;

      // Mock discount calculation (replace with actual API call)
      if (code.toLowerCase() == 'save10') {
        discount.value = subtotal.value * 0.1;
      } else {
        discount.value = 0.0;
      }

      _calculateCartTotals();

      Get.snackbar(
        'Success',
        discount.value > 0
            ? 'Coupon applied successfully!'
            : 'Invalid coupon code',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      _logger.e('Error applying coupon: $e');
      couponCode.value = '';
      discount.value = 0.0;
      _calculateCartTotals();
    } finally {
      isUpdating.value = false;
    }
  }

  // Get cart summary (matches Bruno: GET /cart/summary)
  Future<void> getCartSummary() async {
    try {
      final summary = await _repository.getCartSummary();

      if (summary != null) {
        final summaryData =
            summary['summary'] as Map<String, dynamic>? ?? summary;
        totalItems.value = summaryData['totalItems'] ?? cartItems.length;
        subtotal.value = (summaryData['subtotal'] ?? 0.0).toDouble();
        tax.value = (summaryData['tax'] ?? 0.0).toDouble();
        shipping.value = (summaryData['shippingCost'] ?? 10.0).toDouble();
        discount.value = (summaryData['discount'] ?? 0.0).toDouble();
        total.value = (summaryData['totalAmount'] ?? 0.0).toDouble();
      }
    } catch (e) {
      _logger.e('Failed to get cart summary: $e');
    }
  }

  // Validate cart (matches Bruno: POST /cart/validate)
  Future<Map<String, dynamic>?> validateCart() async {
    try {
      return await _repository.validateCart();
    } catch (e) {
      _logger.e('Failed to validate cart: $e');
      return null;
    }
  }

  // Check cart promotions (matches Bruno: POST /cart/check-promotions)
  Future<Map<String, dynamic>?> checkCartPromotions() async {
    try {
      final cartItemsData =
          cartItems
              .map(
                (item) => {
                  'productId': item.productId,
                  'quantity': item.quantity,
                  if (item.variantId.isNotEmpty) 'variantId': item.variantId,
                },
              )
              .toList();

      return await _repository.checkCartPromotions(cartItemsData);
    } catch (e) {
      _logger.e('Failed to check promotions: $e');
      return null;
    }
  }

  // Helper methods
  void _calculateCartTotals() {
    subtotal.value = cartItems.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    totalItems.value = cartItems.fold(0, (sum, item) => sum + item.quantity);

    // Calculate tax (10% of subtotal)
    tax.value = subtotal.value * 0.1;

    // Calculate total
    total.value = subtotal.value + shipping.value + tax.value - discount.value;
  }

  void _clearCartState() {
    cartItems.clear();
    totalItems.value = 0;
    subtotal.value = 0.0;
    tax.value = 0.0;
    shipping.value = 10.0;
    discount.value = 0.0;
    total.value = 0.0;
    couponCode.value = '';
    cartId.value = '';
  }

  // Convenience methods for UI
  bool get isEmpty => cartItems.isEmpty;
  bool get isNotEmpty => cartItems.isNotEmpty;
  bool isCartEmpty() => cartItems.isEmpty;

  CartItem? getCartItemById(String cartItemId) {
    try {
      return cartItems.firstWhere((item) => item.id == cartItemId);
    } catch (e) {
      return null;
    }
  }

  int getItemQuantityByProductId(String productId) {
    try {
      final item = cartItems.firstWhere((item) => item.productId == productId);
      return item.quantity;
    } catch (e) {
      return 0;
    }
  }

  bool isProductInCart(String productId) {
    return cartItems.any((item) => item.productId == productId);
  }
}
