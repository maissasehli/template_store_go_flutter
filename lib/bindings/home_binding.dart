// lib/bindings/home_bindings.dart
import 'package:get/get.dart';
import 'package:store_go/controller/cart/cart_controller.dart';
import 'package:store_go/controller/categories/category_controller.dart';
import 'package:store_go/controller/home/home_controller.dart';
import 'package:store_go/controller/product/product_controller.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    // Register controllers needed for home and related screens
    Get.put(CartController());
    Get.put(CategoryController());
    Get.put(ProductController());
    Get.put(HomeController());
  }
}