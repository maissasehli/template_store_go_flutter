import 'package:get/get.dart';
import 'package:store_go/features/product/controllers/product_controller.dart';
import 'package:store_go/features/product/models/product_model.dart';

class SearchPageController extends GetxController {
  final ProductController _productController = Get.find<ProductController>();

  // Observable properties
  final RxList<Product> searchResults = <Product>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasResults = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Constructor
  SearchPageController();

  // Search products method
  Future<void> searchProducts(String query) async {
    searchQuery.value = query;

    if (query.trim().isEmpty) {
      searchResults.clear();
      hasResults.value = false;
      return;
    }

    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      // Use the ProductController's search method
      await _productController.searchProducts(query);

      // Copy results from the product controller
      searchResults.assignAll(_productController.searchResults);

      // Update UI state
      hasResults.value = searchResults.isNotEmpty;
      hasError.value = _productController.hasError.value;
      errorMessage.value = _productController.errorMessage.value;
    } catch (e) {
      hasError.value = true;
      errorMessage.value =
          'An error occurred while searching. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  // Navigate to product detail
  void onProductTap(String productId) {
    Get.toNamed('/product/$productId');
  }

  // Toggle favorite status
  Future<void> toggleFavorite(String productId) async {
    await _productController.toggleFavorite(productId);

    // Refresh the search results to reflect favorite status changes
    final updatedResults =
        searchResults.map((product) {
          return product.id == productId
              ? product.copyWith(isFavorite: !product.isFavorite)
              : product;
        }).toList();

    searchResults.assignAll(updatedResults);
  }
}
