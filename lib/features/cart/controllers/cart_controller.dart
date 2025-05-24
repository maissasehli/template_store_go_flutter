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
    } catch (e) {
      _logger.e('Error adding product to cart: $e');
      // Re-throw to let the calling widget handle it
      rethrow;
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
    } catch (e) {
      _logger.e('Error adding product to cart: $e');
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
      await _repository.updateCartItem(
        cartItemId: cartItemId,
        quantity: quantity,
        variants: variants,
      );

      // Refresh cart to get updated data
      await fetchCart();
    } catch (e) {
      _logger.e('Error updating cart item: $e');
      rethrow;
    }
  }

  // Update quantity by cart item ID (now uses optimistic updates by default)
  Future<void> updateCartItemQuantity(String cartItemId, int quantity) async {
    if (quantity <= 0) {
      await removeCartItemOptimistic(cartItemId);
      return;
    }

    await updateCartItemQuantityOptimistic(cartItemId, quantity);
  }

  // Update the existing removeCartItem method to be optimistic by default
  Future<void> removeCartItem(String cartItemId) async {
    await removeCartItemOptimistic(cartItemId);
  }

  // Keep the original methods with different names for when you need the old behavior
  Future<void> updateCartItemWithRefresh(
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
      rethrow;
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> removeCartItemWithRefresh(String cartItemId) async {
    try {
      isUpdating.value = true;

      await _repository.removeFromCart(cartItemId);

      // Refresh cart to get updated data
      await fetchCart();
    } catch (e) {
      _logger.e('Error removing cart item: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  // Update cart item quantity optimistically
  Future<void> updateCartItemQuantityOptimistic(
    String cartItemId,
    int newQuantity,
  ) async {
    // Find the cart item
    final itemIndex = cartItems.indexWhere((item) => item.id == cartItemId);
    if (itemIndex == -1) return;

    final originalItem = cartItems[itemIndex];

    // Optimistically update the UI immediately using copyWith
    cartItems[itemIndex] = originalItem.copyWith(quantity: newQuantity);
    _calculateCartTotals();

    try {
      // Make the API call in the background without showing loading
      await _repository.updateCartItem(
        cartItemId: cartItemId,
        quantity: newQuantity,
      );
    } catch (e) {
      // Revert on error
      cartItems[itemIndex] = originalItem;
      _calculateCartTotals();

      _logger.e('Error updating cart item quantity: $e');

      // Show error to user
      Get.snackbar(
        'Error',
        'Failed to update quantity',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    }
  }

  // Optimistic remove item - no loading states
  Future<void> removeCartItemOptimistic(String cartItemId) async {
    // Find the cart item
    final itemIndex = cartItems.indexWhere((item) => item.id == cartItemId);
    if (itemIndex == -1) return;

    final removedItem = cartItems[itemIndex];

    // Optimistically remove from UI immediately
    cartItems.removeAt(itemIndex);
    _calculateCartTotals();

    try {
      // Make the API call in the background without showing loading
      await _repository.removeFromCart(cartItemId);
    } catch (e) {
      // Revert on error
      cartItems.insert(itemIndex, removedItem);
      _calculateCartTotals();

      _logger.e('Error removing cart item: $e');

      // Show error to user
      Get.snackbar(
        'Error',
        'Failed to remove item',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    }
  }

  // Clear entire cart with optimistic update
  Future<void> clearCart() async {
    // Store original state for potential revert
    final originalItems = List<CartItem>.from(cartItems);
    final originalTotals = {
      'subtotal': subtotal.value,
      'total': total.value,
      'totalItems': totalItems.value,
      'tax': tax.value,
      'shipping': shipping.value,
      'discount': discount.value,
    };

    try {
      // Optimistically clear the UI immediately
      _clearCartState();

      // Make the API call in the background
      await _repository.clearCart();

      // Success - show confirmation
      Get.snackbar(
        'Success',
        'Cart cleared successfully',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      // Revert on error
      cartItems.value = originalItems;
      subtotal.value = originalTotals['subtotal'] as double;
      total.value = originalTotals['total'] as double;
      totalItems.value = originalTotals['totalItems'] as int;
      tax.value = originalTotals['tax'] as double;
      shipping.value = originalTotals['shipping'] as double;
      discount.value = originalTotals['discount'] as double;

      _logger.e('Error clearing cart: $e');

      // Show error to user
      Get.snackbar(
        'Error',
        'Failed to clear cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
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
                  if (item.variants != null && item.variants!.isNotEmpty)
                    'variantId': item.variantId,
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

  /// Check if a product with specific variants is in cart
  bool isProductInCartWithVariants(
    String productId,
    Map<String, String>? variants,
  ) {
    return cartItems.any((item) {
      if (item.productId != productId) return false;

      // Convert variants map to individual properties for comparison
      final itemColor = item.selectedColor ?? '';
      final itemSize = item.selectedSize ?? '';
      final variantColor = variants?['color'] ?? '';
      final variantSize = variants?['size'] ?? '';

      // If both have no variants, they match
      if (itemColor.isEmpty &&
          itemSize.isEmpty &&
          variantColor.isEmpty &&
          variantSize.isEmpty) {
        return true;
      }

      // Compare color and size
      return itemColor == variantColor && itemSize == variantSize;
    });
  }

  /// Get cart item for product with specific variants
  CartItem? getCartItemWithVariants(
    String productId,
    Map<String, String>? variants,
  ) {
    try {
      return cartItems.firstWhere((item) {
        if (item.productId != productId) return false;

        // Convert variants map to individual properties for comparison
        final itemColor = item.selectedColor ?? '';
        final itemSize = item.selectedSize ?? '';
        final variantColor = variants?['color'] ?? '';
        final variantSize = variants?['size'] ?? '';

        // If both have no variants, they match
        if (itemColor.isEmpty &&
            itemSize.isEmpty &&
            variantColor.isEmpty &&
            variantSize.isEmpty) {
          return true;
        }

        // Compare color and size
        return itemColor == variantColor && itemSize == variantSize;
      });
    } catch (e) {
      return null;
    }
  }

  /// Remove cart item with specific variants
  Future<void> removeFromCartWithVariants(
    String productId,
    Map<String, String>? variants,
  ) async {
    final cartItem = getCartItemWithVariants(productId, variants);
    if (cartItem != null) {
      await removeCartItem(cartItem.id);
    }
  }
}
