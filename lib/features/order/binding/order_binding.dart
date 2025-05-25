import 'package:get/get.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/order/controller/order_controller.dart';
import 'package:store_go/features/order/repositories/order_repository.dart';

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    // Register OrderRepository
    Get.lazyPut<OrderRepository>(
      () => OrderRepository(apiClient: Get.find<ApiClient>()),
    );

    // Register OrderController
    Get.lazyPut<OrderController>(
      () => OrderController(repository: Get.find<OrderRepository>()),
    );
  }
}
