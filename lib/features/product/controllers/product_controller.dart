import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/product/models/product_modal.dart';
import 'package:store_go/features/product/services/product_service.dart';

class ProductController extends GetxController {
  final ProductService _productService = Get.find<ProductService>();

  // Observable states for product listing
  final RxList<Product> products = <Product>[].obs;
  final RxList<Product> featuredProducts = <Product>[].obs;
  final RxList<Product> newProducts = <Product>[].obs;
  final RxList<Product> searchResults = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllProducts();
    fetchFeaturedProducts();
    fetchNewProducts();
  }

  // Fetch all products
  Future<void> fetchAllProducts() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final fetchedProducts = await _productService.getProducts();
      products.assignAll(fetchedProducts);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      Logger().e('Error fetching products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch products by category
  Future<void> fetchProductsByCategory(String categoryId) async {
    try {
      isLoading.value = true;
      hasError.value = false;

      if (categoryId.isEmpty) {
        // If no category selected, show all products
        await fetchAllProducts();
        return;
      }

      final categoryProducts = await _productService.getProductsByCategory(
        categoryId,
      );
      products.assignAll(categoryProducts);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      Logger().e('Error fetching products by category: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch featured products
  Future<void> fetchFeaturedProducts() async {
    try {
      final featured = await _productService.getFeaturedProducts();
      featuredProducts.assignAll(featured);
    } catch (e) {
      Logger().e('Error fetching featured products: $e');
      // If featured fails, we can still show other sections
    }
  }

  // Fetch new products
  Future<void> fetchNewProducts() async {
    try {
      final newItems = await _productService.getNewProducts();
      newProducts.assignAll(newItems);
    } catch (e) {
      Logger().e('Error fetching new products: $e');
      // If new products fail, we can still show other sections
    }
  }

  // Search products
  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    try {
      isLoading.value = true;
      final results = await _productService.searchProducts(query);
      searchResults.assignAll(results);
    } catch (e) {
      Logger().e('Error searching products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle favorite status across all product lists
  Future<void> toggleFavorite(String productId) async {
    _toggleFavoriteInList(products, productId);
    _toggleFavoriteInList(featuredProducts, productId);
    _toggleFavoriteInList(newProducts, productId);
    _toggleFavoriteInList(searchResults, productId);

    // Get the new favorite status from any of the updated products
    bool? newFavoriteStatus;
    for (var list in [products, featuredProducts, newProducts, searchResults]) {
      final index = list.indexWhere((p) => p.id == productId);
      if (index != -1) {
        newFavoriteStatus = list[index].isFavorite;
        break;
      }
    }

    // If we couldn't find the product in any list, we can't proceed
    if (newFavoriteStatus == null) return;

    try {
      // Send update to API
      final success = await _productService.updateFavoriteStatus(
        productId,
        newFavoriteStatus,
      );

      // If API call failed, revert the changes
      if (!success) {
        _revertFavoriteChange(productId, !newFavoriteStatus);
      }
    } catch (e) {
      // If there was an error, revert the changes
      _revertFavoriteChange(productId, !newFavoriteStatus);
      Logger().e('Error updating favorite status: $e');
    }
  }

  // Helper method to toggle favorite status in a specific list
  void _toggleFavoriteInList(RxList<Product> productList, String productId) {
    final index = productList.indexWhere((p) => p.id == productId);
    if (index != -1) {
      final product = productList[index];
      productList[index] = product.copyWith(isFavorite: !product.isFavorite);
    }
  }

  // Helper method to revert favorite state if API call fails
  void _revertFavoriteChange(String productId, bool originalState) {
    for (var list in [products, featuredProducts, newProducts, searchResults]) {
      final index = list.indexWhere((p) => p.id == productId);
      if (index != -1) {
        final product = list[index];
        list[index] = product.copyWith(isFavorite: originalState);
      }
    }
  }

  // Clear all filters and reset to original products state
  Future<void> clearFilters() async {
    try {
      // Reset all filter-related state
      isLoading.value = true;

      // Fetch all products without filters
      await fetchAllProducts();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      Logger().e('Error clearing filters: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Filter products based on provided criteria
  Future<void> filterProducts({
    String? category,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    int? rating,
  }) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      // Start with all products (or you could optimize by fetching filtered results from API)
      // First get all products if we don't have them yet
      if (products.isEmpty) {
        await fetchAllProducts();
      }

      // Create a copy to filter
      List<Product> filteredProducts = List.from(products);

      // Apply category filter if provided
      if (category != null && category != 'All') {
        filteredProducts =
            filteredProducts.where((p) => p.category == category).toList();
      }

      // Apply price range filter
      if (minPrice != null && maxPrice != null) {
        filteredProducts =
            filteredProducts
                .where((p) => p.price >= minPrice && p.price <= maxPrice)
                .toList();
      }

      // Apply rating filter
      if (rating != null && rating > 0) {
        filteredProducts =
            filteredProducts.where((p) => p.rating >= rating).toList();
      }

      // Apply sorting
      if (sortBy != null) {
        switch (sortBy) {
          case 'New Today':
            // Assuming newer products have higher IDs or another property
            filteredProducts.sort((a, b) => b.id.compareTo(a.id));
            break;
          case 'Top Sellers':
            // Assuming you track sales or popularity - here using rating as a proxy
            filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
            break;
          case 'New collection':
            // This might be based on a specific category or tag
            filteredProducts.sort((a, b) => b.id.compareTo(a.id));
            break;
        }
      }

      // Update the products list with filtered results
      products.assignAll(filteredProducts);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      Logger().e('Error applying filters: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
