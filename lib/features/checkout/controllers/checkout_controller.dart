import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/features/cart/models/cart_model.dart';
import 'package:store_go/features/order/model/order_model.dart';
import 'package:store_go/features/order/repositories/order_repository.dart';
import 'package:store_go/features/payment/services/payment_service.dart';
import 'package:store_go/features/payment/models/payment_result_model.dart';

class CheckoutController extends GetxController {
  // Use dependency injection instead of creating a new instance
  OrderRepository get _orderRepository => Get.find<OrderRepository>();
  PaymentService get _paymentService => Get.find<PaymentService>();

  final RxBool isProcessing = false.obs;
  final Rx<Address?> selectedShippingAddress = Rx<Address?>(null);
  final Rx<Address?> selectedBillingAddress = Rx<Address?>(null);
  final RxString selectedPaymentMethod = ''.obs;
  final RxString currentOrderId = ''.obs;

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

  /// Enhanced checkout method that creates order and processes payment
  Future<String> createOrderAndProcessPayment({
    required List<CartItem> cartItems,
    required double subtotal,
    required double tax,
    required double shippingCost,
    required double discount,
    required double total,
    Map<String, dynamic>? cardDetails,
    bool savePaymentMethod = false,
  }) async {
    try {
      isProcessing.value = true;

      // Step 1: Create order
      final orderId = await createOrder(
        cartItems: cartItems,
        subtotal: subtotal,
        tax: tax,
        shippingCost: shippingCost,
        discount: discount,
        total: total,
      );

      currentOrderId.value = orderId;

      // Step 2: Process payment if card details provided
      if (cardDetails != null) {
        final paymentResult = await processPaymentForOrder(
          orderId: orderId,
          cardDetails: cardDetails,
          savePaymentMethod: savePaymentMethod,
        );

        if (paymentResult.isSuccess) {
          Get.snackbar(
            'checkout.success_title'.translate(),
            'checkout.payment_success_message'.translate(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          // Navigate to order confirmation
          Get.offAllNamed(
            '/order-confirmation',
            parameters: {'orderId': orderId},
          );
        } else if (paymentResult.isRequiresAction) {
          // Handle 3D Secure authentication
          await handle3DSecure(paymentResult);
        } else {
          throw Exception(paymentResult.message);
        }
      }

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

  /// Create order request using the correct OrderRequest from order/model
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

      // Create order request
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

  /// Process payment for an existing order
  Future<PaymentResult> processPaymentForOrder({
    required String orderId,
    required Map<String, dynamic> cardDetails,
    bool savePaymentMethod = false,
  }) async {
    try {
      // Step 1: Create payment method using Stripe
      final paymentMethod = await _paymentService.createPaymentMethod(
        cardDetails: cardDetails,
        billingDetails:
            selectedBillingAddress.value?.toJson() ??
            selectedShippingAddress.value?.toJson(),
      );

      // Step 2: Process payment
      final paymentResult = await _paymentService.processPayment(
        orderId: orderId,
        paymentMethodId: paymentMethod.id,
        savePaymentMethod: savePaymentMethod,
      );

      return paymentResult;
    } catch (e) {
      return PaymentResult.failed(
        orderId: orderId,
        error: e.toString(),
        message: 'Payment processing failed: ${e.toString()}',
      );
    }
  }

  /// Handle 3D Secure authentication
  Future<void> handle3DSecure(PaymentResult paymentResult) async {
    if (!paymentResult.isRequiresAction ||
        paymentResult.clientSecret == null ||
        paymentResult.paymentIntentId == null) {
      throw Exception('Invalid 3D Secure parameters');
    }

    try {
      final authResult = await _paymentService.handle3DSecure(
        clientSecret: paymentResult.clientSecret!,
        paymentIntentId: paymentResult.paymentIntentId!,
        orderId: paymentResult.orderId ?? currentOrderId.value,
      );

      if (authResult.isSuccess) {
        Get.snackbar(
          'checkout.success_title'.translate(),
          'checkout.payment_success_message'.translate(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offAllNamed(
          '/order-confirmation',
          parameters: {'orderId': authResult.orderId ?? currentOrderId.value},
        );
      } else {
        throw Exception(authResult.message);
      }
    } catch (e) {
      Get.snackbar(
        'checkout.error_title'.translate(),
        '3D Secure authentication failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
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
