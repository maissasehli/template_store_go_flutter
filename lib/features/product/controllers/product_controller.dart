import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/product/models/product_modal.dart';
import 'package:store_go/features/product/services/product_service.dart';

class ProductController extends GetxController {
  final ProductService _productService = Get.find<ProductService>();

  // Observable states
  final RxList<Product> products = <Product>[].obs;
  final RxList<Product> featuredProducts = <Product>[].obs;
  final RxList<Product> newProducts = <Product>[].obs;
  final RxList<Product> searchResults = <Product>[].obs;
  final Rx<Product?> selectedProduct = Rx<Product?>(null);
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isDetailsLoading = false.obs; // New for details
  final RxString detailsError = ''.obs; // New for details

  @override
  void onInit() {
    super.onInit();
    fetchAllProducts();
    fetchFeaturedProducts();
    fetchNewProducts();
  }

  // Add this new method to fetch product details
  Future<void> fetchProductDetails(String productId) async {
    try {
      isDetailsLoading.value = true;
      detailsError.value = '';
      selectedProduct.value = null; // Clear previous product

      final product = await _productService.getProductById(productId);
      Logger().i('Fetched product: ${product.toJson()}');
      selectedProduct.value = product;
    } catch (e) {
      selectedProduct.value = null;
      detailsError.value = e.toString();
      Logger().e('Error fetching product details: $e');
    } finally {
      isDetailsLoading.value = false;
    }
  }

  // Existing methods remain unchanged...
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
      print('Error fetching products: $e');
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
      print('Error fetching featured products: $e');
      // If featured fails, we can still show other sections
    }
  }

  // Fetch new products
  Future<void> fetchNewProducts() async {
    try {
      final newItems = await _productService.getNewProducts();
      newProducts.assignAll(newItems);
    } catch (e) {
      print('Error fetching new products: $e');
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
      print('Error searching products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle favorite status (optimistic update)
  Future<void> toggleFavorite(String productId) async {
    // Find product in all lists
    final productIndex = products.indexWhere((p) => p.id == productId);
    final featuredIndex = featuredProducts.indexWhere((p) => p.id == productId);
    final newIndex = newProducts.indexWhere((p) => p.id == productId);

    // Update state optimistically (before API confirms)
    if (productIndex != -1) {
      final product = products[productIndex];
      final updatedProduct = product.copyWith(isFavorite: !product.isFavorite);
      products[productIndex] = updatedProduct;
    }

    if (featuredIndex != -1) {
      final product = featuredProducts[featuredIndex];
      final updatedProduct = product.copyWith(isFavorite: !product.isFavorite);
      featuredProducts[featuredIndex] = updatedProduct;
    }

    if (newIndex != -1) {
      final product = newProducts[newIndex];
      final updatedProduct = product.copyWith(isFavorite: !product.isFavorite);
      newProducts[newIndex] = updatedProduct;
    }

    // Update in search results if present
    final searchIndex = searchResults.indexWhere((p) => p.id == productId);
    if (searchIndex != -1) {
      final product = searchResults[searchIndex];
      final updatedProduct = product.copyWith(isFavorite: !product.isFavorite);
      searchResults[searchIndex] = updatedProduct;
    }

    // Update selected product if it's the same one
    if (selectedProduct.value?.id == productId) {
      final currentProduct = selectedProduct.value!;
      selectedProduct.value = currentProduct.copyWith(
        isFavorite: !currentProduct.isFavorite,
      );
    }

    // Get the new favorite status from any of the updated products
    bool newFavoriteStatus = false;
    if (productIndex != -1) {
      newFavoriteStatus = products[productIndex].isFavorite;
    } else if (featuredIndex != -1) {
      newFavoriteStatus = featuredProducts[featuredIndex].isFavorite;
    } else if (newIndex != -1) {
      newFavoriteStatus = newProducts[newIndex].isFavorite;
    } else if (selectedProduct.value?.id == productId) {
      newFavoriteStatus = selectedProduct.value!.isFavorite;
    }

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
      print('Error updating favorite status: $e');
    }
  }

  // Helper method to revert favorite state if API call fails
  void _revertFavoriteChange(String productId, bool originalState) {
    // Find and update in all lists
    final productIndex = products.indexWhere((p) => p.id == productId);
    if (productIndex != -1) {
      final product = products[productIndex];
      products[productIndex] = product.copyWith(isFavorite: originalState);
    }

    final featuredIndex = featuredProducts.indexWhere((p) => p.id == productId);
    if (featuredIndex != -1) {
      final product = featuredProducts[featuredIndex];
      featuredProducts[featuredIndex] = product.copyWith(
        isFavorite: originalState,
      );
    }

    final newIndex = newProducts.indexWhere((p) => p.id == productId);
    if (newIndex != -1) {
      final product = newProducts[newIndex];
      newProducts[newIndex] = product.copyWith(isFavorite: originalState);
    }

    final searchIndex = searchResults.indexWhere((p) => p.id == productId);
    if (searchIndex != -1) {
      final product = searchResults[searchIndex];
      searchResults[searchIndex] = product.copyWith(isFavorite: originalState);
    }

    // Update selected product if it's the same one
    if (selectedProduct.value?.id == productId) {
      final currentProduct = selectedProduct.value!;
      selectedProduct.value = currentProduct.copyWith(
        isFavorite: originalState,
      );
    }
  }

  // Clear all filters and reset to original products state
  Future<void> clearFilters() async {
    try {
      // Reset all filter-related state
      isLoading.value = true;

      // Fetch all products without filters
      await fetchAllProducts();

      // You might want to reset the UI state in the SearchScreen after this
      // But that would be handled in the UI side
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      print('Error clearing filters: $e');
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
            // You might need to adjust this based on your actual data structure
            filteredProducts.sort((a, b) => b.id.compareTo(a.id));
            break;
          case 'Top Sellers':
            // Assuming you track sales or popularity - here using rating as a proxy
            filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
            break;
          case 'New collection':
            // This might be based on a specific category or tag
            // For now, similar to New Today
            filteredProducts.sort((a, b) => b.id.compareTo(a.id));
            break;
        }
      }

      // Update the products list with filtered results
      products.assignAll(filteredProducts);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      print('Error applying filters: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
