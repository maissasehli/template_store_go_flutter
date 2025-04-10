// File: cart_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/cart/models/cart.dart';

// Abstract class defining the contract for cart controllers
abstract class CartController extends GetxController {
  // Abstract getters
  RxList<CartItem> get cartItems;
  double get subtotal;
  double get shippingCost;
  double get tax;
  double get total;
  RxString get couponCode;
  
  // Abstract methods
  void loadInitialData();
  void updateQuantity(int index, int change);
  void removeItem(int index);
  void onCouponCodeChanged(String value);
  void applyCoupon();
  void navigateToCheckout();
  void navigateToCategories();
  void goBack();
  void confirmItemRemoval(int index);
}

// Implementation of the abstract CartController
class CartControllerImp extends CartController {
  final RxList<CartItem> _cartItems = <CartItem>[].obs;
  final RxString _couponCode = ''.obs;
  
  @override
  RxList<CartItem> get cartItems => _cartItems;
  
  @override
  RxString get couponCode => _couponCode;

  @override
  void onInit() {
    super.onInit();
    // Load initial data
    loadInitialData();
  }

  @override
  void loadInitialData() {
    _cartItems.addAll([
      CartItem(
        id: '1',
        name: 'Roller Rabbit',
        description: 'Vado Odelle Dress',
        price: 198.00,
        quantity: 1,
        imageUrl: 'assets/products/tshirt_white.png',
      ),
      CartItem(
        id: '2',
        name: 'Axel Arigato',
        description: 'Clean 90 Triple Sneakers',
        price: 245.00,
        quantity: 1,
        imageUrl: 'assets/products/tshirt_white.png',
      ),
      CartItem(
        id: '3',
        name: 'Herschel Supply Co.',
        description: 'Daypack Backpack',
        price: 40.00,
        quantity: 1,
        imageUrl: 'assets/products/tshirt_white.png',
      ),
    ]);
  }

  @override
  double get subtotal {
    return _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  @override
  double get shippingCost => 8.00;
  
  @override
  double get tax => 0.00;
  
  @override
  double get total => subtotal + shippingCost + tax;

  @override
  void updateQuantity(int index, int change) {
    final newQuantity = _cartItems[index].quantity + change;
    if (newQuantity > 0) {
      _cartItems[index].quantity = newQuantity;
      _cartItems.refresh(); // Notify listeners
    }
  }

  @override
  void removeItem(int index) {
    _cartItems.removeAt(index);
  }

  @override
  void onCouponCodeChanged(String value) {
    _couponCode.value = value;
  }

  @override
  void applyCoupon() {
    // Logic to apply coupon code
    // For now, just print the code
    print('Applying coupon: ${_couponCode.value}');
  }

  @override
  void navigateToCheckout() {
    Get.toNamed('/checkout');
  }

  @override
  void navigateToCategories() {
    Get.toNamed('/categories');
  }

  @override
  void goBack() {
    Get.back();
  }

  @override
  void confirmItemRemoval(int index) {
    Get.dialog(
      AlertDialog(
        title: const Text('Remove Item'),
        content: const Text(
          'Are you sure you want to remove this item from your cart?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              removeItem(index);
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}