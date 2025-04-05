import 'package:get/get.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/features/category/services/category_api_service.dart';
import 'package:store_go/features/category/services/category_service.dart';

class CategoryBinding implements Bindings {
  @override
  void dependencies() {
    // These controllers are needed on the home screen but might be reused
    Get.lazyPut<CategoryApiService>(
      () => CategoryApiService(Get.find<ApiClient>()),
    );
    Get.lazyPut<CategoryService>(
      () => CategoryService(Get.find<CategoryApiService>()),
    );
    Get.lazyPut<CategoryController>(
      () => CategoryController(Get.find<CategoryService>()),
    );
  }
}
