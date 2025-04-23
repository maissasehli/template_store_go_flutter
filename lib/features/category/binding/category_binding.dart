import 'package:get/get.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/features/category/repositories/category_repository.dart';

class CategoryBinding implements Bindings {
  @override
  void dependencies() {
    // Register the API client if not already registered elsewhere
    if (!Get.isRegistered<ApiClient>()) {
      Get.put(ApiClient());
    }

    // Register the repository
    Get.put(CategoryRepository(apiClient: Get.find<ApiClient>()));

    // Register the controller with its dependencies
    Get.put(CategoryController(repository: Get.find<CategoryRepository>()));
  }
}