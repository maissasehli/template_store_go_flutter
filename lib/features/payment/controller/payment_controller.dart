import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/payment/repositories/payment_repository.dart';

class PaymentController extends GetxController {
  final PaymentRepository _repository;
  final Logger _logger = Logger();

  final RxList<PaymentMethod> paymentMethods = <PaymentMethod>[].obs;
  final Rx<PaymentMethod?> selectedPaymentMethod = Rx<PaymentMethod?>(null);
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  PaymentController({required PaymentRepository repository}) : _repository = repository;

  @override
  void onInit() {
    super.onInit();
    fetchPaymentMethods();
  }

  Future<void> fetchPaymentMethods() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final methods = await _repository.getPaymentMethods();
      paymentMethods.value = methods;
      selectedPaymentMethod.value = methods.firstWhereOrNull((method) => method.isDefault) ?? methods.firstOrNull;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      _logger.e('Error fetching payment methods: $e');
      Get.snackbar('Error', 'Failed to load payment methods', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addPaymentMethod(PaymentMethod method) async {
    try {
      isLoading.value = true;
      final newMethod = await _repository.addPaymentMethod(method);
      paymentMethods.add(newMethod);
      if (newMethod.isDefault || paymentMethods.length == 1) {
        selectedPaymentMethod.value = newMethod;
      }
    } catch (e) {
      _logger.e('Error adding payment method: $e');
      Get.snackbar('Error', 'Failed to add payment method', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void selectPaymentMethod(PaymentMethod method) {
    selectedPaymentMethod.value = method;
  }
}