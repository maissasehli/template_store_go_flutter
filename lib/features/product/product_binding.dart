import 'package:get/get.dart';
import 'package:store_go/features/product/controllers/product_controller.dart';
import 'package:store_go/features/product/controllers/product_detail_controller.dart';
import 'package:store_go/features/product/services/product_service.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    // Register services
    Get.lazyPut<ProductService>(() => ProductService());

    // Register controllers
    Get.lazyPut<ProductController>(() => ProductController());
    Get.lazyPut<ProductDetailController>(() => ProductDetailController());
  }
}
