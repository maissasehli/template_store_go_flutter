import 'package:get/get.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/features/category/repositories/category_repository.dart';
import 'package:store_go/features/category/services/category_api_service.dart';
import 'package:store_go/features/category/services/category_service.dart';
import 'package:store_go/features/home/controllers/home_controller.dart';
import 'package:store_go/features/product/controllers/product_controller.dart';
import 'package:store_go/features/product/services/product_service.dart';
import 'package:store_go/features/profile/controllers/profile_controller.dart';
import 'package:store_go/features/profile/repositories/profile_repository.dart';
import 'package:store_go/features/wishlist/controllers/wishlist_controller.dart';
import 'package:store_go/features/wishlist/repositories/wishlist_repository.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    // These controllers are needed on the home screen but might be reused
    Get.lazyPut<ProductController>(() => ProductController(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController());

    // Add these lines to register CategoryController and its dependencies
    Get.lazyPut<CategoryApiService>(
      () => CategoryApiService(Get.find<ApiClient>()),
    );
    Get.lazyPut<CategoryService>(
      () => CategoryService(Get.find<CategoryApiService>()),
    );
    Get.lazyPut<CategoryController>(
      () => CategoryController(repository: Get.find<CategoryRepository>()),
    );
    Get.lazyPut<ProductService>(() => ProductService(), fenix: true);
    // Register controller
    Get.lazyPut<WishlistController>(
      () => WishlistController(repository: Get.find<WishlistRepository>()),
    );
    final apiClient = Get.find<ApiClient>();
    Get.lazyPut<WishlistRepository>(
      () => WishlistRepository(apiClient: apiClient),
    );

    Get.lazyPut<CategoryRepository>(
      () => CategoryRepository(apiClient: Get.find<ApiClient>()),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(repository: Get.find<ProfileRepository>()),
    );
    Get.lazyPut<ProfileRepository>(
      () => ProfileRepository(apiClient: Get.find<ApiClient>()),
    );
  }
}
