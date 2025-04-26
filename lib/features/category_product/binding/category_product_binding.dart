import 'package:get/get.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/features/category/repositories/category_repository.dart';
import 'package:store_go/features/filter/controllers/product_filter_controller.dart';
import 'package:store_go/features/product/controllers/product_controller.dart';
import 'package:store_go/features/product/controllers/product_list_controller.dart';
import 'package:store_go/features/product/repositories/product_repository.dart';
import 'package:store_go/features/profile/controllers/profile_controller.dart';
import 'package:store_go/features/profile/repositories/profile_repository.dart';
import 'package:store_go/features/subcategory/controllers/subcategory_controller.dart';
import 'package:store_go/features/subcategory/repositories/subcategory_repository.dart';

class CategoryProductsBinding extends Bindings { 
  @override
  void dependencies() {
    final apiClient = Get.find<ApiClient>();

    // Register repositories
 Get.lazyPut(() => ProductRepository(
          apiClient: Get.find<ApiClient>(),
        ), fenix: true);
    Get.lazyPut<CategoryRepository>(
      () => CategoryRepository(apiClient: apiClient),
    );
    Get.lazyPut<SubcategoryRepository>(
      () => SubcategoryRepository(apiClient: apiClient),
    );
    Get.lazyPut<ProfileRepository>(
      () => ProfileRepository(apiClient: apiClient),
    );

    // Register controllers
    Get.lazyPut<ProductController>(
      () => ProductController(repository: Get.find<ProductRepository>()),
    );
    Get.lazyPut<CategoryController>(
      () => CategoryController(repository: Get.find<CategoryRepository>()),
    );
    Get.lazyPut<SubcategoryController>(
      () => SubcategoryController(repository: Get.find<SubcategoryRepository>()),
    );
    Get.lazyPut<ProductFilterController>(
      () => ProductFilterController(productController: Get.find<ProductController>()),
    );
    Get.lazyPut<ProductListController>(
      () => ProductListController(
        productController: Get.find<ProductController>(),
        filterController: Get.find<ProductFilterController>(),
      ),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(repository: Get.find<ProfileRepository>()),
    );
  }
}