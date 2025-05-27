import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import '../models/payment_method_model.dart';
import '../models/payment_history_model.dart';
import '../models/payment_result_model.dart';
import '../services/payment_service.dart';

class PaymentController extends GetxController {
  final PaymentService _paymentService;
  final Logger _logger = Logger();

  // Payment methods
  final RxList<PaymentMethod> paymentMethods = <PaymentMethod>[].obs;
  final Rx<PaymentMethod?> selectedPaymentMethod = Rx<PaymentMethod?>(null);

  // Payment history
  final RxList<PaymentHistory> paymentHistory = <PaymentHistory>[].obs;

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isProcessingPayment = false.obs;
  final RxBool isLoadingHistory = false.obs;

  // Error handling
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Payment result
  final Rx<PaymentResult?> lastPaymentResult = Rx<PaymentResult?>(null);

  PaymentController({required PaymentService paymentService})
    : _paymentService = paymentService;

  @override
  void onInit() {
    super.onInit();
    fetchPaymentMethods();
  }

  /// Fetch all saved payment methods
  Future<void> fetchPaymentMethods() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final methods = await _paymentService.getSavedPaymentMethods();
      paymentMethods.value = methods;

      // Select default payment method or first one
      selectedPaymentMethod.value =
          methods.firstWhereOrNull((method) => method.isDefault) ??
          methods.firstOrNull;

      _logger.i('Fetched ${methods.length} payment methods');
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      _logger.e('Error fetching payment methods: $e');
      _showErrorSnackbar('Failed to load payment methods');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch payment history
  Future<void> fetchPaymentHistory({int page = 1, int limit = 20}) async {
    try {
      isLoadingHistory.value = true;

      final history = await _paymentService.getPaymentHistory(
        page: page,
        limit: limit,
      );

      if (page == 1) {
        paymentHistory.value = history;
      } else {
        paymentHistory.addAll(history);
      }

      _logger.i('Fetched ${history.length} payment history records');
    } catch (e) {
      _logger.e('Error fetching payment history: $e');
      _showErrorSnackbar('Failed to load payment history');
    } finally {
      isLoadingHistory.value = false;
    }
  }

  /// Create and save a new payment method
  Future<bool> createAndSavePaymentMethod({
    required String cardNumber,
    required int expiryMonth,
    required int expiryYear,
    required String cvc,
    required String cardholderName,
    String? email,
    bool setAsDefault = false,
  }) async {
    try {
      isLoading.value = true;

      final newMethod = await _paymentService.createAndSavePaymentMethod(
        cardNumber: cardNumber,
        expiryMonth: expiryMonth,
        expiryYear: expiryYear,
        cvc: cvc,
        cardholderName: cardholderName,
        email: email,
        setAsDefault: setAsDefault,
      );

      paymentMethods.add(newMethod);

      if (newMethod.isDefault || paymentMethods.length == 1) {
        selectedPaymentMethod.value = newMethod;
      }

      _showSuccessSnackbar('Payment method added successfully');
      _logger.i('Payment method created: ${newMethod.id}');
      return true;
    } catch (e) {
      _logger.e('Error creating payment method: $e');
      _showErrorSnackbar('Failed to add payment method: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete a payment method
  Future<bool> deletePaymentMethod(String paymentMethodId) async {
    try {
      isLoading.value = true;

      await _paymentService.deletePaymentMethod(paymentMethodId);

      paymentMethods.removeWhere((method) => method.id == paymentMethodId);

      // If deleted method was selected, select first available
      if (selectedPaymentMethod.value?.id == paymentMethodId) {
        selectedPaymentMethod.value = paymentMethods.firstOrNull;
      }

      _showSuccessSnackbar('Payment method deleted');
      _logger.i('Payment method deleted: $paymentMethodId');
      return true;
    } catch (e) {
      _logger.e('Error deleting payment method: $e');
      _showErrorSnackbar('Failed to delete payment method');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Set a payment method as default
  Future<bool> setDefaultPaymentMethod(String paymentMethodId) async {
    try {
      isLoading.value = true;

      final updatedMethod = await _paymentService.setDefaultPaymentMethod(
        paymentMethodId,
      );

      // Update the payment methods list
      final index = paymentMethods.indexWhere(
        (method) => method.id == paymentMethodId,
      );
      if (index != -1) {
        // Set all methods as non-default first
        for (int i = 0; i < paymentMethods.length; i++) {
          paymentMethods[i] = paymentMethods[i].copyWith(isDefault: false);
        }
        // Set the selected method as default
        paymentMethods[index] = updatedMethod;
        selectedPaymentMethod.value = updatedMethod;
      }

      _showSuccessSnackbar('Default payment method updated');
      _logger.i('Default payment method set: $paymentMethodId');
      return true;
    } catch (e) {
      _logger.e('Error setting default payment method: $e');
      _showErrorSnackbar('Failed to update default payment method');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Process payment for an order
  Future<PaymentResult> processPayment({
    required String orderId,
    required double amount,
    required String currency,
    String? paymentMethodId,
    bool savePaymentMethod = false,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      isProcessingPayment.value = true;

      final result = await _paymentService.processPayment(
        orderId: orderId,
        amount: amount,
        currency: currency,
        paymentMethodId: paymentMethodId ?? selectedPaymentMethod.value?.id,
        savePaymentMethod: savePaymentMethod,
        metadata: metadata,
      );

      lastPaymentResult.value = result;

      if (result.isSuccess) {
        _showSuccessSnackbar('Payment completed successfully');
        // Refresh payment history
        fetchPaymentHistory();
      } else if (result.isFailed) {
        _showErrorSnackbar(result.message);
      }

      _logger.i('Payment processed: ${result.status}');
      return result;
    } catch (e) {
      _logger.e('Error processing payment: $e');
      final failedResult = PaymentResult.failed(
        orderId: orderId,
        error: e.toString(),
        message: 'Payment failed: $e',
      );
      lastPaymentResult.value = failedResult;
      _showErrorSnackbar('Payment failed');
      return failedResult;
    } finally {
      isProcessingPayment.value = false;
    }
  }

  /// Handle 3D Secure authentication
  Future<PaymentResult> handle3DSecure(String clientSecret) async {
    try {
      isProcessingPayment.value = true;

      final result = await _paymentService.handle3DSecure(
        clientSecret: clientSecret,
      );

      lastPaymentResult.value = result;

      if (result.isSuccess) {
        _showSuccessSnackbar('Payment completed successfully');
        fetchPaymentHistory();
      } else if (result.isFailed) {
        _showErrorSnackbar(result.message);
      }

      return result;
    } catch (e) {
      _logger.e('Error handling 3D Secure: $e');
      final failedResult = PaymentResult.failed(
        error: e.toString(),
        message: 'Authentication failed: $e',
      );
      lastPaymentResult.value = failedResult;
      _showErrorSnackbar('Authentication failed');
      return failedResult;
    } finally {
      isProcessingPayment.value = false;
    }
  }

  /// Select a payment method
  void selectPaymentMethod(PaymentMethod method) {
    selectedPaymentMethod.value = method;
    _logger.i('Selected payment method: ${method.id}');
  }

  /// Clear error state
  void clearError() {
    hasError.value = false;
    errorMessage.value = '';
  }

  /// Validate card details
  bool validateCardNumber(String cardNumber) {
    return _paymentService.validateCardNumber(cardNumber);
  }

  bool validateExpiryDate(String expiryDate) {
    return _paymentService.validateExpiryDate(expiryDate);
  }

  bool validateCVC(String cvc) {
    return _paymentService.validateCVC(cvc);
  }

  /// Format card number for display
  String formatCardNumber(String cardNumber) {
    return _paymentService.formatCardNumber(cardNumber);
  }

  /// Helper methods for UI feedback
  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'common.success'.translate(),
      message.translate(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.primaryColor,
      colorText: Get.theme.colorScheme.onPrimary,
    );
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'common.error'.translate(),
      message.translate(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
    );
  }

  @override
  void onClose() {
    super.onClose();
    _logger.i('PaymentController disposed');
  }
}
