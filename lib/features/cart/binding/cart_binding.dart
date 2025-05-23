import 'package:get/get.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/cart/controllers/cart_controller.dart';
import 'package:store_go/features/cart/repositories/cart_repository.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure ApiClient is available
    if (!Get.isRegistered<ApiClient>()) {
      Get.put<ApiClient>(ApiClient(), permanent: true);
    }

    // Register CartRepository
    Get.lazyPut<CartRepository>(() => CartRepository(), fenix: true);

    // Register CartController with repository dependency
    Get.lazyPut<CartController>(
      () => CartController(repository: Get.find<CartRepository>()),
      fenix: true,
    );
  }
}
