// lib/bindings/home_bindings.dart
import 'package:get/get.dart';
import 'package:store_go/controller/categories/category_controller.dart';
import 'package:store_go/controller/home/home_controller.dart';
import 'package:store_go/controller/product/product_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    // These controllers are needed on the home screen but might be reused
    Get.lazyPut<CategoryController>(() => CategoryController(), fenix: true);
    Get.lazyPut<ProductController>(() => ProductController(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
