import 'package:get/get.dart';

class PaymentMethodModel {
  final String id;
  final String type; // 'card' or 'paypal'
  final String maskedNumber; // For cards
  final String email; // For PayPal
  final String cardType; // For cards: 'mastercard', 'visa', etc.

  PaymentMethodModel({
    required this.id,
    required this.type,
    this.maskedNumber = '',
    this.email = '',
    this.cardType = '',
  });
}

class PaymentController extends GetxController {
  final RxList<PaymentMethodModel> paymentMethods = <PaymentMethodModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Load dummy data for demonstration
    loadInitialPaymentMethods();
  }

  void loadInitialPaymentMethods() {
    paymentMethods.addAll([
      PaymentMethodModel(
        id: '1',
        type: 'card',
        maskedNumber: '**** 4187',
        cardType: 'mastercard',
      ),
      PaymentMethodModel(
        id: '2',
        type: 'card',
        maskedNumber: '**** 9387',
        cardType: 'mastercard',
      ),
      PaymentMethodModel(
        id: '3',
        type: 'paypal',
        email: 'Cloth@gmail.com',
      ),
    ]);
  }

  void addPaymentMethod(PaymentMethodModel paymentMethod) {
    paymentMethods.add(paymentMethod);
    Get.back();
    Get.snackbar('Success', 'Payment method added successfully',
        snackPosition: SnackPosition.BOTTOM);
  }

  void editPaymentMethod(String id, PaymentMethodModel updatedMethod) {
    final index = paymentMethods.indexWhere((method) => method.id == id);
    if (index != -1) {
      paymentMethods[index] = updatedMethod;
      Get.back();
      Get.snackbar('Success', 'Payment method updated successfully',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void deletePaymentMethod(String id) {
    paymentMethods.removeWhere((method) => method.id == id);
    Get.snackbar('Success', 'Payment method removed successfully',
        snackPosition: SnackPosition.BOTTOM);
  }
}