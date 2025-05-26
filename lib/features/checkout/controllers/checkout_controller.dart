import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/features/cart/models/cart_model.dart';
import 'package:store_go/features/order/model/order_model.dart';
import 'package:store_go/features/order/repositories/order_repository.dart';
import 'package:store_go/features/payment/services/payment_service.dart';
import 'package:store_go/features/payment/models/payment_result_model.dart';
import 'package:store_go/features/address/controller/address_controller.dart';
import 'package:store_go/features/address/model/address_model.dart'
    as AddressModel;
import 'package:store_go/features/profile/controllers/profile_controller.dart';

class CheckoutController extends GetxController {
  // Use dependency injection instead of creating a new instance
  OrderRepository get _orderRepository => Get.find<OrderRepository>();
  PaymentService get _paymentService => Get.find<PaymentService>();
  final RxBool isProcessing = false.obs;
  final Rx<AddressModel.Address?> selectedShippingAddress =
      Rx<AddressModel.Address?>(null);
  final Rx<AddressModel.Address?> selectedBillingAddress =
      Rx<AddressModel.Address?>(null);
  final RxString selectedPaymentMethod = ''.obs;
  final RxString currentOrderId = ''.obs;
  final RxBool isLoadingAddress = false.obs;
  @override
  void onInit() {
    super.onInit();
    _ensureProfileController();
    _initializeDefaultAddress();
    _listenToAddressChanges();
  }

  @override
  void onReady() {
    super.onReady();
    // Refresh addresses when the controller is ready
    refreshAddresses();
  }

  @override
  void onClose() {
    // Clean up any listeners if needed
    super.onClose();
  }

  /// Initialize profile controller if needed
  void _ensureProfileController() {
    try {
      if (!Get.isRegistered<ProfileController>()) {
        // If ProfileController isn't registered, we'll try to register it
        // This should normally be done during app initialization
        print(
          'ProfileController not registered, user data may not be available',
        );
      }
    } catch (e) {
      print('Error ensuring profile controller: $e');
    }
  }

  /// Initialize default address from address controller
  void _initializeDefaultAddress() async {
    try {
      isLoadingAddress.value = true;

      // Ensure AddressController is available
      if (!Get.isRegistered<AddressController>()) {
        // Register AddressController if not already registered
        Get.put(AddressController());
      }

      final addressController = Get.find<AddressController>();

      // Ensure addresses are loaded
      await addressController.fetchAddresses();

      // Find default address
      _updateSelectedAddress();
    } catch (e) {
      print('Error loading default address: $e');
    } finally {
      isLoadingAddress.value = false;
    }
  }

  /// Listen to changes in the address controller
  void _listenToAddressChanges() {
    try {
      // Ensure AddressController is available before setting up listener
      if (!Get.isRegistered<AddressController>()) {
        Get.put(AddressController());
      }

      // Listen to address list changes
      ever(Get.find<AddressController>().addresses, (_) {
        _updateSelectedAddress();
      });
    } catch (e) {
      print('Error setting up address change listener: $e');
    }
  }

  /// Update selected address based on current addresses
  void _updateSelectedAddress() {
    final addressController = Get.find<AddressController>();

    // Check if current selected address still exists and is still default
    if (selectedShippingAddress.value != null) {
      final currentAddress = addressController.addresses.firstWhereOrNull(
        (addr) => addr.id == selectedShippingAddress.value!.id,
      );

      if (currentAddress == null) {
        // Current address was deleted, clear it
        selectedShippingAddress.value = null;
      } else if (!currentAddress.isDefault) {
        // Current address is no longer default, clear it to find new default
        selectedShippingAddress.value = null;
      }
    }

    // If no address is selected, find the current default one
    if (selectedShippingAddress.value == null) {
      final defaultAddress = addressController.addresses.firstWhereOrNull(
        (address) => address.isDefault,
      );

      if (defaultAddress != null) {
        selectedShippingAddress.value = defaultAddress;
      }
    }
  }

  void navigateToAddressSelection() {
    // Navigate to address selection screen and refresh when returning
    Get.toNamed('/address')?.then((_) {
      // Refresh addresses when returning from address screen
      refreshAddresses();
    });
  }

  /// Refresh addresses and update selected address
  Future<void> refreshAddresses() async {
    try {
      final addressController = Get.find<AddressController>();
      await addressController.fetchAddresses();
      _updateSelectedAddress();
    } catch (e) {
      print('Error refreshing addresses: $e');
    }
  }

  /// Clear selected address and refresh from current default
  void clearAndRefreshSelectedAddress() {
    selectedShippingAddress.value = null;
    selectedBillingAddress.value = null;
    _updateSelectedAddress();
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
      isProcessing.value = true; // Create order request
      final orderRequest = OrderRequest(
        shippingAddress:
            selectedShippingAddress.value != null
                ? _convertToOrderAddress(selectedShippingAddress.value!)
                : _getDefaultAddress(),
        billingAddress:
            selectedBillingAddress.value != null
                ? _convertToOrderAddress(selectedBillingAddress.value!)
                : (selectedShippingAddress.value != null
                    ? _convertToOrderAddress(selectedShippingAddress.value!)
                    : _getDefaultAddress()),
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
            selectedBillingAddress.value != null
                ? _addressToJson(selectedBillingAddress.value!)
                : (selectedShippingAddress.value != null
                    ? _addressToJson(selectedShippingAddress.value!)
                    : null),
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
    // No longer return hardcoded default address
    // Force user to select a proper address instead of using fake data
    throw Exception(
      'No shipping address selected. Please add or select a default address.',
    );
  }

  /// Convert AddressModel.Address to Order Address
  Address _convertToOrderAddress(AddressModel.Address address) {
    // Get user data from profile
    final userData = _getUserProfileData();

    return Address(
      firstName: userData['firstName']!,
      lastName: userData['lastName']!,
      street: address.street,
      city: address.city,
      state: address.state,
      zipCode: address.postalCode,
      country: address.country,
      phone: userData['phone']!,
    );
  }

  /// Convert AddressModel.Address to JSON for billing details
  Map<String, dynamic> _addressToJson(AddressModel.Address address) {
    // Get user data from profile
    final userData = _getUserProfileData();

    return {
      'name': '${userData['firstName']} ${userData['lastName']}',
      'email': userData['email'],
      'phone': userData['phone'],
      'address': {
        'line1': address.street,
        'city': address.city,
        'state': address.state,
        'postal_code': address.postalCode,
        'country': address.country,
      },
    };
  }

  /// Get the display text for shipping address section
  String get shippingAddressDisplayText {
    if (selectedShippingAddress.value != null) {
      return selectedShippingAddress.value!.formattedAddress;
    }
    return 'checkout.add_shipping_address'.translate();
  }

  /// Check if a default address is selected
  bool get hasSelectedAddress => selectedShippingAddress.value != null;

  /// Get user profile data for address completion
  Map<String, String> _getUserProfileData() {
    try {
      if (Get.isRegistered<ProfileController>()) {
        final profileController = Get.find<ProfileController>();
        final user = profileController.user.value;

        if (user != null) {
          final nameParts = user.name.split(' ');
          return {
            'firstName': nameParts.isNotEmpty ? nameParts.first : 'User',
            'lastName':
                nameParts.length > 1 ? nameParts.sublist(1).join(' ') : 'Name',
            'phone': user.phone ?? '+1-555-0123',
            'email': user.email,
          };
        }
      }
    } catch (e) {
      print('Error getting user profile data: $e');
    }

    // Return default values if profile not available
    return {
      'firstName': 'User',
      'lastName': 'Name',
      'phone': '+1-555-0123',
      'email': 'user@example.com',
    };
  }
}
