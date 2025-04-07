import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/cart/models/cart_model.dart';

/// Controller responsible for managing the shopping cart
class CartController extends GetxController {
  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final RxDouble subtotal = 0.0.obs;
  final RxDouble shipping = 0.0.obs;
  final RxDouble tax = 0.0.obs;
  final RxDouble total = 0.0.obs;
  final Logger _logger = Logger();

  @override
  void onInit() {
    super.onInit();
    // Load cart from storage or API
    loadCart();

    // Set up reaction to recalculate totals when cart changes
    ever(cartItems, (_) => calculateTotals());
  }

  /// Loads cart from storage or API
  void loadCart() {
    // Implementation depends on your storage/API
    // For now, just initialize an empty cart
  }

  /// Calculates cart totals
  void calculateTotals() {
    double subTotal = 0;

    for (var item in cartItems) {
      subTotal += item.price * item.quantity;
    }

    subtotal.value = subTotal;
    shipping.value = subTotal > 0 ? 5.0 : 0.0; // Example shipping fee
    tax.value = subTotal * 0.1; // Example 10% tax
    total.value = subtotal.value + shipping.value + tax.value;
  }

  /// Adds a product to the cart
  Future<void> addToCart({
    required String productId,
    required int quantity,
    Map<String, String>? variants,
  }) async {
    try {
      // Check if item already exists in cart
      final existingIndex = cartItems.indexWhere(
        (item) =>
            item.productId == productId &&
            _areVariantsEqual(item.variants, variants),
      );

      if (existingIndex != -1) {
        // Update quantity if item exists
        final item = cartItems[existingIndex];
        final updatedItem = item.copyWith(quantity: item.quantity + quantity);
        cartItems[existingIndex] = updatedItem;
      } else {
        // Add new item if it doesn't exist
        // Here you would typically fetch the product details
        // For now, we'll use a placeholder
        final cartItem = CartItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          productId: productId,
          name: 'Product Name', // Replace with actual product name
          price: 0.0, // Replace with actual price
          quantity: quantity,
          variants: variants ?? {},
          image: '', // Replace with actual image
        );

        cartItems.add(cartItem);
      }

      // Update cart in storage or API
      await saveCart();
    } catch (e) {
      _logger.e('Error adding to cart: $e');
      rethrow;
    }
  }

  /// Removes an item from the cart
  Future<void> removeFromCart(String cartItemId) async {
    try {
      cartItems.removeWhere((item) => item.id == cartItemId);
      await saveCart();
    } catch (e) {
      _logger.e('Error removing from cart: $e');
      rethrow;
    }
  }

  /// Updates quantity of an item in the cart
  Future<void> updateQuantity(String cartItemId, int quantity) async {
    try {
      final index = cartItems.indexWhere((item) => item.id == cartItemId);

      if (index != -1) {
        if (quantity <= 0) {
          // Remove item if quantity is 0 or negative
          await removeFromCart(cartItemId);
        } else {
          // Update quantity
          final item = cartItems[index];
          cartItems[index] = item.copyWith(quantity: quantity);
          await saveCart();
        }
      }
    } catch (e) {
      _logger.e('Error updating cart quantity: $e');
      rethrow;
    }
  }

  /// Saves cart to storage or API
  Future<void> saveCart() async {
    // Implementation depends on your storage/API
    // For now, just log that we're saving
    _logger.i('Saving cart with ${cartItems.length} items');
  }

  /// Helper method to compare variant maps
  bool _areVariantsEqual(
    Map<String, String> variants1,
    Map<String, String>? variants2,
  ) {
    if (variants2 == null) return variants1.isEmpty;
    if (variants1.length != variants2.length) return false;

    for (final entry in variants1.entries) {
      if (variants2[entry.key] != entry.value) return false;
    }

    return true;
  }

  /// Clears the cart
  Future<void> clearCart() async {
    cartItems.clear();
    await saveCart();
  }
}
