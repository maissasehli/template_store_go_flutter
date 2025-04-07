import 'package:get/get.dart';
import 'package:store_go/features/product/controllers/product_list_controller.dart';
import 'package:store_go/features/product/controllers/product_detail_controller.dart';
import 'package:store_go/features/product/controllers/favorite_controller.dart';
import 'package:store_go/features/product/repositories/product_repository.dart';
import 'package:store_go/features/product/services/product_service.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    // Register services
    Get.lazyPut<ProductService>(() => ProductService());

    // Register repositories
    Get.lazyPut<ProductRepository>(
      () => ProductRepository(Get.find<ProductService>()),
    );

    // Register controllers
    Get.lazyPut<ProductListController>(() => ProductListController());
    Get.lazyPut<ProductDetailController>(() => ProductDetailController());
    Get.lazyPut<FavoriteController>(() => FavoriteController());
  }
}
