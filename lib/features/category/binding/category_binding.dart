import 'package:get/get.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/features/category/repositories/category_repository.dart';
import 'package:store_go/features/category/services/category_api_service.dart';
import 'package:store_go/features/category/services/category_service.dart';

class CategoryBinding implements Bindings {
  @override
  void dependencies() {
    // Register the API client if not already registered elsewhere
    if (!Get.isRegistered<ApiClient>()) {
      Get.lazyPut<ApiClient>(() => ApiClient());
    }

    // Register the API service
    Get.lazyPut<CategoryApiService>(
      () => CategoryApiService(Get.find<ApiClient>()),
    );

    // Register the service
    Get.lazyPut<CategoryService>(
      () => CategoryService(Get.find<CategoryApiService>()),
    );

    // Add this line to register the repository
    Get.lazyPut<CategoryRepository>(
      () => CategoryRepository(apiClient: Get.find<ApiClient>()),
    );

    // Register the controller with its dependencies
    Get.lazyPut<CategoryController>(
      () => CategoryController(repository: Get.find<CategoryRepository>()),
    );
  }
}
