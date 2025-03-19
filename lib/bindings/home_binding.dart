// lib/bindings/home_bindings.dart
import 'package:get/get.dart';
import 'package:store_go/controller/categories/category_controller.dart';
import 'package:store_go/controller/home/home_controller.dart';
import 'package:store_go/controller/product/product_controller.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(CategoryController());
    Get.put(ProductController());
    Get.put(HomeController());

  }
}