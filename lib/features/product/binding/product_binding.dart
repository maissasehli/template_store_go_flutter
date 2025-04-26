import 'package:get/get.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/features/category/repositories/category_repository.dart';
import 'package:store_go/features/filter/controllers/product_filter_controller.dart';
import 'package:store_go/features/product/controllers/product_controller.dart';
import 'package:store_go/features/product/controllers/product_list_controller.dart';
import 'package:store_go/features/product/controllers/product_detail_controller.dart';
import 'package:store_go/features/product/controllers/favorite_controller.dart';
import 'package:store_go/features/product/repositories/product_repository.dart';
import 'package:store_go/features/review/repositories/review_repository.dart';
import 'package:store_go/features/review/controllers/review_controller.dart';
import 'package:store_go/features/subcategory/controllers/subcategory_controller.dart';
import 'package:store_go/features/subcategory/repositories/subcategory_repository.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    final apiClient = Get.find<ApiClient>();
    
    // Register repositories
    Get.lazyPut(() => ReviewRepository(apiClient: apiClient));
    
    Get.lazyPut(() => ProductRepository(
      apiClient: apiClient,
    ));
    
    Get.lazyPut(() => CategoryRepository(apiClient: apiClient));
    
    Get.lazyPut(() => SubcategoryRepository(apiClient: apiClient));
    
    // Register controllers
    Get.lazyPut(() => ReviewController(repository: Get.find<ReviewRepository>()));
    
    Get.lazyPut(() => ProductController(repository: Get.find<ProductRepository>()));
    
    Get.lazyPut(() => CategoryController(repository: Get.find<CategoryRepository>()));
    
    Get.lazyPut(() => SubcategoryController(repository: Get.find<SubcategoryRepository>()));
    
    Get.lazyPut(() => ProductFilterController(productController: Get.find<ProductController>()));
    
    Get.lazyPut(() => ProductListController(
      productController: Get.find<ProductController>(),
      filterController: Get.find<ProductFilterController>(),
    ));
    
    Get.lazyPut(() => ProductDetailController(
      repository: Get.find<ProductRepository>(),
      reviewRepository: Get.find<ReviewRepository>(),
    ));
    
    Get.lazyPut(() => FavoriteController(repository: Get.find<ProductRepository>()));
  }
}