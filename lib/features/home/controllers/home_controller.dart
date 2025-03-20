// For HomeController.dart
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/app/core/controllers/navigation_controller.dart';
import 'package:store_go/features/product/controllers/product_controller.dart';
import 'package:store_go/features/home/models/category_model.dart';
import 'package:store_go/features/category/services/category_api_service.dart';

class HomeController extends GetxController {
  final CategoryController categoryController = Get.find<CategoryController>();
  final ProductController productController = Get.find<ProductController>();
  final NavigationController navigationController = Get.find<NavigationController>();
  final CategoryApiService categoryApiService = Get.find<CategoryApiService>();

  // Track which section's "See All" was clicked
  final RxString currentSection = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize data when controller is created
    productController.fetchProducts();
  }

  // Navigate to product detail page
  void navigateToProductDetail(String productId) {
    Get.toNamed('/product/$productId', arguments: productId);
  }

  // Navigate to category page for all products in a category
  void navigateToCategoryScreen(String categoryId) {
    final category = categoryController.categories.firstWhere(
      (c) => c.id == categoryId,
      orElse: () => Category(id: categoryId, name: 'Category'),
    );
    Get.toNamed('/category/$categoryId', arguments: category);
  }

  // Handle See All button click for Categories
  void onCategoriesSeeAllTap() {
    currentSection.value = 'categories';
    Get.toNamed('/categories');
    final categories = categoryApiService.getCategories();
    Logger().i("Found categories : $categories");
  }

  // Handle See All button click for Top Selling products
  void onTopSellingSeeAllTap() {
    currentSection.value = 'topSelling';
    Get.toNamed('/products/featured', arguments: {'title': 'Top Selling'});
  }

  // Handle See All button click for New In products
  void onNewInSeeAllTap() {
    currentSection.value = 'newIn';
    Get.toNamed('/products/new', arguments: {'title': 'New In'});
  }

  // Handle product tap from any section
  void onProductTap(String productId) {
    navigateToProductDetail(productId);
  }

  // Handle category tap
}
