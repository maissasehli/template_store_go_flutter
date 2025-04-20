import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/cart/models/cart_model.dart';
import 'package:store_go/features/cart/reposetories/cart_repository.dart';
import 'package:store_go/features/product/models/product_model.dart';

class CartController extends GetxController {
  final CartRepository _repository;
  final Logger _logger = Logger();

  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString couponCode = ''.obs;

  final RxDouble subtotal = 0.0.obs;
  final RxDouble shipping = 0.0.obs;
  final RxDouble tax = 0.0.obs;
  final RxDouble discount = 0.0.obs;
  final RxDouble total = 0.0.obs;

  CartController({required CartRepository repository}) : _repository = repository;

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    try {
      isLoading.value = true;
      isError.value = false;
      errorMessage.value = '';

      final items = await _repository.getCartItems();
      cartItems.value = items;
      _calculateCartTotals();
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString();
      _logger.e('Error fetching cart items: $e');
      Get.snackbar('Error', 'Failed to load cart', snackPosition: SnackPosition.BOTTOM);
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
      errorMessage.value = '';

      final tempItem = CartItem(
        id: DateTime.now().toString(),
        productId: product.id,
        name: product.name,
        price: product.price,
        quantity: quantity,
        variants: variants,
        image: product.images.isNotEmpty ? product.images.first : '',
      );

      cartItems.add(tempItem);
      _calculateCartTotals();

      await _repository.addToCart(tempItem);
      await fetchCartItems();
    } catch (e) {
      cartItems.removeWhere((item) => item.productId == product.id);
      _calculateCartTotals();

      isError.value = true;
      errorMessage.value = e.toString();
      _logger.e('Error adding to cart: $e');
      Get.snackbar('Error', 'Failed to add item to cart', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    try {
      isLoading.value = true;
      isError.value = false;
      errorMessage.value = '';

      final item = cartItems.firstWhere((item) => item.productId == productId);
      final updatedItem = item.copyWith(quantity: quantity);

      final index = cartItems.indexWhere((item) => item.productId == productId);
      cartItems[index] = updatedItem;
      _calculateCartTotals();

      await _repository.updateCartItem(updatedItem);
      await fetchCartItems();
    } catch (e) {
      await fetchCartItems();

      isError.value = true;
      errorMessage.value = e.toString();
      _logger.e('Error updating cart item: $e');
      Get.snackbar('Error', 'Failed to update cart item', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeFromCart(String productId) async {
    final itemsToRemove = cartItems.where((item) => item.productId == productId).toList();
    try {
      isLoading.value = true;
      isError.value = false;
      errorMessage.value = '';

      cartItems.removeWhere((item) => item.productId == productId);
      _calculateCartTotals();

      await _repository.removeFromCart(productId);
    } catch (e) {
      cartItems.addAll(itemsToRemove);
      _calculateCartTotals();

      isError.value = true;
      errorMessage.value = e.toString();
      _logger.e('Error removing from cart: $e');
      Get.snackbar('Error', 'Failed to remove item from cart', snackPosition: SnackPosition.BOTTOM);

      await fetchCartItems();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> clearCart() async {
    final itemsToRestore = cartItems.toList();
    try {
      isLoading.value = true;
      isError.value = false;
      errorMessage.value = '';

      cartItems.clear();
      _calculateCartTotals();

      await _repository.clearCart();
    } catch (e) {
      cartItems.addAll(itemsToRestore);
      _calculateCartTotals();

      isError.value = true;
      errorMessage.value = e.toString();
      _logger.e('Error clearing cart: $e');
      Get.snackbar('Error', 'Failed to clear cart', snackPosition: SnackPosition.BOTTOM);

      await fetchCartItems();
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
      errorMessage.value = '';

      couponCode.value = code;
      final discountAmount = await _repository.applyCoupon(code);
      discount.value = discountAmount;
      _calculateCartTotals();
    } catch (e) {
      couponCode.value = '';
      discount.value = 0.0;
      _calculateCartTotals();

      isError.value = true;
      errorMessage.value = e.toString();
      _logger.e('Error applying coupon: $e');
      Get.snackbar('Error', 'Failed to apply coupon', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void _calculateCartTotals() {
    subtotal.value = cartItems.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
    shipping.value = 10.0;
    tax.value = subtotal.value * 0.1;
    total.value = subtotal.value + shipping.value + tax.value - discount.value;
  }

  bool isCartEmpty() => cartItems.isEmpty;

  bool isProductInCart(String productId) => cartItems.any((item) => item.productId == productId);
}