import 'package:get/get.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/cart/controllers/cart_controller.dart';
import 'package:store_go/features/cart/reposetory/cart_repository.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/features/category/repositories/category_repository.dart';
import 'package:store_go/features/category/services/category_api_service.dart';
import 'package:store_go/features/category/services/category_service.dart';
import 'package:store_go/features/home/controllers/home_controller.dart';
import 'package:store_go/features/product/controllers/category_product_controller.dart';
import 'package:store_go/features/product/controllers/product_controller.dart';
import 'package:store_go/features/product/repositories/product_repository.dart';
import 'package:store_go/features/profile/controllers/profile_controller.dart';
import 'package:store_go/features/profile/repositories/profile_repository.dart';
import 'package:store_go/features/wishlist/controllers/wishlist_controller.dart';
import 'package:store_go/features/wishlist/repositories/wishlist_repository.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    final apiClient = Get.find<ApiClient>();
    // These controllers are needed on the home screen but might be reused
    Get.lazyPut<ProductController>(() => ProductController(repository: ProductRepository(apiClient: apiClient)), fenix: true);
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
    // Register controller
    Get.lazyPut<WishlistController>(
      () => WishlistController(repository: Get.find<WishlistRepository>()),
    );
    
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
     Get.put<ProductRepository>(
      ProductRepository(apiClient: Get.find<ApiClient>()),
      permanent: true,
    );
     Get.lazyPut<CategoryProductController>(
    () => CategoryProductController(
      repository: Get.find<ProductRepository>(),
    ), 
    fenix: true, // This will recreate the controller if it was deleted
  );
      Get.put(CartRepository(apiClient: Get.find<ApiClient>()), permanent: true);

      Get.put(CartController(repository: Get.find<CartRepository>()), permanent: true);

  }
}
