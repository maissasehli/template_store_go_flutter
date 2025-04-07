import 'package:get/get.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/features/product/controllers/product_controller.dart';
import 'package:store_go/app/core/config/routes_config.dart';

class HomeController extends GetxController {
  final CategoryController categoryController = Get.find<CategoryController>();
  final ProductController productController = Get.put(ProductController());

  @override
  void onInit() {
    super.onInit();

    // Listen to category changes to update products
    ever(categoryController.selectedCategoryId, (String? categoryId) {
      if (categoryId != null && categoryId.isNotEmpty) {
        productController.fetchProductsByCategory(categoryId);
      } else {
        productController.fetchAllProducts();
      }
    });
  }

  void onCategoriesSeeAllTap() {
    Get.toNamed(AppRoute.categories);
  }

  void onTopSellingSeeAllTap() {
    Get.toNamed(AppRoute.products, arguments: {'title': 'Top Selling'});
  }

  void onNewInSeeAllTap() {
    Get.toNamed(AppRoute.products, arguments: {'title': 'New In'});
  }

  void onProductTap(String productId) {
    Get.toNamed('/products/$productId');
  }
}
