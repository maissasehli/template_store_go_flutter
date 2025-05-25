import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/features/cart/models/cart_model.dart';
import 'package:store_go/features/order/model/order_model.dart';
import 'package:store_go/features/order/repositories/order_repository.dart';

class CheckoutController extends GetxController {
  // Use dependency injection instead of creating a new instance
  OrderRepository get _orderRepository => Get.find<OrderRepository>();

  final RxBool isProcessing = false.obs;
  final Rx<Address?> selectedShippingAddress = Rx<Address?>(null);
  final Rx<Address?> selectedBillingAddress = Rx<Address?>(null);
  final RxString selectedPaymentMethod = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize any required data
  }

  void navigateToAddressSelection() {
    // Navigate to address selection screen
    Get.toNamed('/address');
  }

  void navigateToPaymentMethodSelection() {
    // Navigate to payment method selection screen
    Get.toNamed('/payments');
  }

  Future<String> createOrder({
    required List<CartItem> cartItems,
    required double subtotal,
    required double tax,
    required double shippingCost,
    required double discount,
    required double total,
  }) async {
    try {
      isProcessing.value = true;

      // Create order request using the correct OrderRequest from order/model
      final orderRequest = OrderRequest(
        shippingAddress: selectedShippingAddress.value ?? _getDefaultAddress(),
        billingAddress:
            selectedBillingAddress.value ??
            selectedShippingAddress.value ??
            _getDefaultAddress(),
        paymentMethod:
            selectedPaymentMethod.value.isNotEmpty
                ? selectedPaymentMethod.value
                : 'credit_card',
        notes: '', // Add notes field if needed
      );

      // Call API to create order
      final orderId = await _orderRepository.createOrder(orderRequest);

      Get.snackbar(
        'checkout.success_title'.translate(),
        'checkout.order_created_message'.translate(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate back to home or orders page
      Get.offAllNamed('/');
      return orderId;
    } catch (e) {
      Get.snackbar(
        'checkout.error_title'.translate(),
        'checkout.error_message'.translate(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isProcessing.value = false;
    }
  }

  Address _getDefaultAddress() {
    // Return a default address or throw error if no address selected
    return Address(
      firstName: 'John',
      lastName: 'Doe',
      street: '123 Main Street',
      city: 'Boston',
      state: 'MA',
      zipCode: '02101',
      country: 'USA',
      phone: '+1-555-0123',
    );
  }
}
