// For HomeController.dart
import 'package:get/get.dart';
import 'package:store_go/controller/categories/category_controller.dart';
import 'package:store_go/controller/product/product_controller.dart';
import 'package:store_go/core/model/home/category_model.dart';

class HomeController extends GetxController {
  final CategoryController categoryController = Get.find<CategoryController>();
  final ProductController productController = Get.find<ProductController>();
  
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
  void onCategoryTap(String categoryId) {
    categoryController.selectedCategoryId.value = categoryId;
    productController.fetchProductsByCategory(categoryId);
  }
}