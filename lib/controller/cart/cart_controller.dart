import 'package:get/get.dart';
import 'package:store_go/core/model/cart/cart.dart';
import 'package:store_go/core/model/home/product_model.dart';

class CartController extends GetxController {
  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final RxDouble subtotal = 0.0.obs;
  final RxDouble tax = 0.0.obs;
  final RxDouble total = 0.0.obs;
  
  void addToCart(
    Product product, 
    Map<String, String> variants, 
    [int quantity = 1]
  ) {
    // Check if the product with same variants is already in cart
    final existingItemIndex = cartItems.indexWhere((item) => 
      item.product.id == product.id && 
      _areVariantsEqual(item.variants, variants)
    );
    
    if (existingItemIndex >= 0) {
      // Increase quantity of existing item
      final existingItem = cartItems[existingItemIndex];
      cartItems[existingItemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + quantity
      );
    } else {
      // Add new item
      cartItems.add(
        CartItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          product: product,
          quantity: quantity,
          variants: variants,
        ),
      );
    }
    
    _calculateTotals();
    
    // Save to local storage if needed
    // _cartService.saveCart(cartItems);
  }
  
  void removeFromCart(String itemId) {
    cartItems.removeWhere((item) => item.id == itemId);
    _calculateTotals();
    
    // Save to local storage if needed
    // _cartService.saveCart(cartItems);
  }
  
  void updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(itemId);
      return;
    }
    
    final index = cartItems.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      final item = cartItems[index];
      cartItems[index] = item.copyWith(quantity: quantity);
      _calculateTotals();
      
      // Save to local storage if needed
      // _cartService.saveCart(cartItems);
    }
  }
  
  void clearCart() {
    cartItems.clear();
    _calculateTotals();
    
    // Save to local storage if needed
    // _cartService.saveCart(cartItems);
  }
  
  void _calculateTotals() {
    double subTotal = 0.0;
    for (var item in cartItems) {
      subTotal += item.product.price * item.quantity;
    }
    
    subtotal.value = subTotal;
    tax.value = subTotal * 0.1; // Assuming 10% tax
    total.value = subtotal.value + tax.value;
  }
  
  bool _areVariantsEqual(Map<String, String> a, Map<String, String> b) {
    if (a.length != b.length) return false;
    
    for (final entry in a.entries) {
      if (b[entry.key] != entry.value) return false;
    }
    
    return true;
  }
}