import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/cart/models/cart_model.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/cart/reposetories/cart_repository.dart';
import 'package:store_go/features/product/models/product_modal.dart';

class CartController extends GetxController {
  final CartRepository _repository;
  final Logger _logger = Logger();

  // Observable state
  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString couponCode = ''.obs;

  // Cart totals
  final RxDouble subtotal = 0.0.obs;
  final RxDouble shipping = 0.0.obs;
  final RxDouble tax = 0.0.obs;
  final RxDouble discount = 0.0.obs;
  final RxDouble total = 0.0.obs;

  CartController({required CartRepository repository})
    : _repository = repository;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  Future<void> loadCart() async {
    try {
      isLoading.value = true;
      isError.value = false;
      errorMessage.value = '';

      // Attempt to load from server, but don't throw if it fails
      try {
        final items = await _repository.getCartItems();
        cartItems.value = items;
      } catch (e) {
        _logger.w('Failed to load cart from server, using local cart: $e');
        // Don't set error state here - we'll just use the local cart
      }

      // Calculate cart totals
      _calculateCartTotals();
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString();
      _logger.e('Error in loadCart(): $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToCart({
    required Product product,
    required int quantity,
    required Map<String, String> variants,
  }) async {
    try {
      isLoading.value = true;
      isError.value = false;

      // In a real app, you'd look up product information here
      // For now, using placeholders
      final name = product.name;
      final price = product.price;
      final image = product.images.isNotEmpty ? product.images.first : '';

      // Create a new cart item
      final item = CartItem(
        id: DateTime.now().toString(), // Temporary ID
        productId: product.id,
        name: name,
        price: price,
        quantity: quantity,
        variants: variants,
        image: image,
      );

      // Optimistic update
      cartItems.add(item);
      _calculateCartTotals();

      // Try to send to server, but don't fail if server is unavailable
      try {
        await _repository.addToCart(item);

        // In a real app with a working API, you'd refresh the cart here
        // await loadCart();
      } catch (e) {
        _logger.w('Failed to add item to server, keeping in local cart: $e');
        // Don't revert the optimistic update - we'll keep it in local state
      }
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString();
      _logger.e('Error in addToCart(): $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateQuantity(String itemId, int quantity) async {
    try {
      final index = cartItems.indexWhere((item) => item.id == itemId);
      if (index == -1) return;

      // Update locally first (optimistic update)
      final updatedItem = cartItems[index].copyWith(quantity: quantity);
      cartItems[index] = updatedItem;
      _calculateCartTotals();

      // Try to update on server, but don't fail if server is unavailable
      try {
        await _repository.updateCartItem(updatedItem);
      } catch (e) {
        _logger.w('Failed to update item on server, keeping local changes: $e');
        // Don't revert the optimistic update - we'll keep it in local state
      }
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString();
      _logger.e('Error in updateQuantity(): $e');
    }
  }

  Future<void> removeFromCart(String itemId) async {
    try {
      // Find the item to remove
      final index = cartItems.indexWhere((item) => item.id == itemId);
      if (index == -1) {
        _logger.w('Item not found in cart: $itemId');
        return;
      }

      // Store the item in case we need to restore it
      final CartItem removedItem = cartItems[index];

      // Optimistic update - remove from UI immediately
      cartItems.removeAt(index);
      _calculateCartTotals();

      try {
        // Try to sync with server, but don't fail if server is unavailable
        await _repository.removeFromCart(removedItem.productId);
        _logger.i('Item successfully removed from cart on server');
      } catch (e) {
        // This catch block should never be reached with our improved repository
        // but keeping it as a failsafe
        _logger.e('Failed to sync cart item removal with server: $e');

        // Show a subtle message that we're in offline mode
        Get.snackbar(
          'Offline Mode',
          'Changes will sync when online',
          duration: 2.seconds,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black54,
          colorText: Colors.white,
        );

        // No need to revert local changes - we're keeping the item removed locally
      }
    } catch (e) {
      // This catch block handles any unexpected errors in the method itself
      _logger.e('Error in removeFromCart: $e');
      Get.snackbar(
        'Error',
        'Failed to remove item',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> clearCart() async {
    try {
      isLoading.value = true;

      // Clear local state
      cartItems.clear();
      _calculateCartTotals();

      // Try to clear on server, but don't fail if server is unavailable
      try {
        await _repository.clearCart();
      } catch (e) {
        _logger.w('Failed to clear cart on server, keeping local changes: $e');
        // Local cart is already cleared, so no need to revert
      }
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString();
      _logger.e('Error in clearCart(): $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> applyCoupon(String code) async {
    if (code.isEmpty) {
      couponCode.value = '';
      discount.value = 0.0;
      _calculateCartTotals();
      return;
    }

    try {
      isLoading.value = true;
      isError.value = false;

      // Store the coupon code
      couponCode.value = code;

      // Try to apply coupon on server, but don't fail if server is unavailable
      double discountAmount = 0.0;
      try {
        discountAmount = await _repository.applyCoupon(code);
      } catch (e) {
        _logger.w(
          'Failed to apply coupon on server, using default discount: $e',
        );
        // Use a default discount for demonstration
        discountAmount = subtotal.value * 0.1; // 10% discount
      }

      // Update discount and recalculate
      discount.value = discountAmount;
      _calculateCartTotals();
    } catch (e) {
      couponCode.value = '';
      discount.value = 0.0;
      _calculateCartTotals();

      isError.value = true;
      errorMessage.value = e.toString();
      _logger.e('Error in applyCoupon(): $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _calculateCartTotals() {
    subtotal.value = cartItems.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
    shipping.value = 10.0; // Static for now
    tax.value = subtotal.value * 0.1; // 10% tax
    total.value = subtotal.value + shipping.value + tax.value - discount.value;
  }

  bool isCartEmpty() {
    return cartItems.isEmpty;
  }

  bool isProductInCart(String productId) {
    return cartItems.any((item) => item.productId == productId);
  }
}