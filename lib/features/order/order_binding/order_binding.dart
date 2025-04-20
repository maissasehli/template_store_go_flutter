import 'package:get/get.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/order/controller/order_controller.dart';
import 'package:store_go/features/order/repositories/order_repository.dart';

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    // Get the ApiClient instance - it should already be registered elsewhere in your app
    final apiClient = Get.find<ApiClient>();
    
    // Create and register the OrderRepository with the ApiClient
    Get.put(OrderRepository(apiClient: apiClient));
    
    // Create and register the OrderController with the OrderRepository
    Get.put(OrderController(repository: Get.find<OrderRepository>()));
  }
}