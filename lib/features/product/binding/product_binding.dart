import 'package:get/get.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/product/controllers/product_list_controller.dart';
import 'package:store_go/features/product/controllers/product_detail_controller.dart';
import 'package:store_go/features/product/controllers/favorite_controller.dart';
import 'package:store_go/features/product/repositories/product_repository.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    final apiClient = Get.find<ApiClient>();

    // Register repositories
    Get.lazyPut<ProductRepository>(
      ()=> ProductRepository(apiClient: apiClient)
    );

    // Register controllers
    Get.lazyPut<ProductListController>(
      () => ProductListController(
        repository: ProductRepository(apiClient: apiClient),
      ),
    );
    Get.lazyPut<ProductDetailController>(() => ProductDetailController(repository: ProductRepository(apiClient: apiClient)));
    Get.lazyPut<FavoriteController>(() => FavoriteController(repository: ProductRepository(apiClient: apiClient)));
  }
}
