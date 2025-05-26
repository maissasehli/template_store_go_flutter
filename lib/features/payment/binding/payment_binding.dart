import 'package:get/get.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/payment/controller/payment_controller.dart';
import 'package:store_go/features/payment/repositories/payment_repository.dart';
import 'package:store_go/features/payment/services/payment_service.dart';
import 'package:store_go/features/payment/services/stripe_service.dart';

class PaymentBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure ApiClient is available
    if (!Get.isRegistered<ApiClient>()) {
      Get.put<ApiClient>(ApiClient(), permanent: true);
    }

    // Register StripeService
    Get.lazyPut<StripeService>(() => StripeService(), fenix: true);

    // Register PaymentRepository
    Get.lazyPut<PaymentRepository>(
      () => PaymentRepository(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );

    // Register PaymentService with proper dependencies
    Get.lazyPut<PaymentService>(
      () => PaymentService(
        paymentRepository: Get.find<PaymentRepository>(),
        stripeService: Get.find<StripeService>(),
      ),
      fenix: true,
    );

    // Register PaymentController
    Get.lazyPut<PaymentController>(
      () => PaymentController(paymentService: Get.find<PaymentService>()),
      fenix: true,
    );
  }
}
