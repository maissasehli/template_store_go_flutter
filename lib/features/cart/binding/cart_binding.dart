import 'package:get/get.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/cart/controllers/cart_controller.dart';
import 'package:store_go/features/cart/repositories/cart_repository.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    final apiClient = Get.find<ApiClient>();
    Get.lazyPut<CartRepository>(() => CartRepository(apiClient: apiClient), fenix: true);
    Get.lazyPut<CartController>(() => CartController(repository: Get.find<CartRepository>()), fenix: true);
  }
}