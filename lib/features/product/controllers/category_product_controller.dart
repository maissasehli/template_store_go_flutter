import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/category/models/category.modal.dart';
import 'package:store_go/features/product/models/product_modal.dart';
import 'package:store_go/features/product/repositories/product_repository.dart';

class CategoryProductController extends GetxController {
  final ProductRepository _repository;
  final Logger _logger = Logger();

  // Observable states
  final RxList<Product> categoryProducts = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  
  // Store current category
  final Rx<Category?> currentCategory = Rx<Category?>(null);
  
  // Search functionality
  final RxString searchQuery = ''.obs;
  final RxBool isSearchActive = false.obs;

  CategoryProductController({required ProductRepository repository})
      : _repository = repository;

  void setCategory(Category category) {
    currentCategory.value = category;
    // Clear any active search when changing categories
    searchQuery.value = '';
    isSearchActive.value = false;
    // Then fetch products for this category
    fetchCategoryProducts(category.id);
  }

  Future<void> fetchCategoryProducts(String categoryId) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      
      final products = await _repository.getProductsByCategory(categoryId);
      
      // Log the number of products received
      _logger.d("Fetched ${products.length} products for category $categoryId");
      
      // Update the products list
      categoryProducts.assignAll(products);
      
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      _logger.e('Error fetching products for category $categoryId: $e');
      // Empty the products list on error
      categoryProducts.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // Search within current category
  Future<void> searchCategoryProducts(String query) async {
    searchQuery.value = query;
    
    if (query.isEmpty) {
      isSearchActive.value = false;
      // If search is cleared, restore original category products
      if (currentCategory.value != null) {
        fetchCategoryProducts(currentCategory.value!.id);
      }
      return;
    }

    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      isSearchActive.value = true;
      
      // For API-based search that supports category filtering:
      // final searchResults = await _repository.searchProductsInCategory(currentCategory.value!.id, query);
      
      // For client-side filtering if your API doesn't support it:
      // First get all products for this category if we don't have them
      List<Product> allCategoryProducts;
      if (categoryProducts.isEmpty && currentCategory.value != null) {
        allCategoryProducts = await _repository.getProductsByCategory(currentCategory.value!.id);
      } else {
        // Use existing products if we already have them
        allCategoryProducts = List.from(categoryProducts);
      }
      
      // Then filter by search query (case insensitive)
      final filteredProducts = allCategoryProducts.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase()) ||
               (product.description?.toLowerCase() ?? '').contains(query.toLowerCase());
      }).toList();
      
      _logger.d("Found ${filteredProducts.length} products matching '$query' in category ${currentCategory.value?.id}");
      
      // Update the products list with search results
      categoryProducts.assignAll(filteredProducts);
      
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      _logger.e('Error searching products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle favorite status
  Future<void> toggleFavorite(String productId) async {
    final productIndex = categoryProducts.indexWhere((p) => p.id == productId);
    if (productIndex == -1) return; // Product not found
    
    final product = categoryProducts[productIndex];
    final newFavoriteStatus = !product.isFavorite;
    
    // Update locally first for immediate UI feedback
    categoryProducts[productIndex] = product.copyWith(isFavorite: newFavoriteStatus);
    
    try {
      // Then update on the server
      final success = await _repository.updateFavoriteStatus(productId, newFavoriteStatus);
      
      if (!success) {
        // Revert if server update failed
        categoryProducts[productIndex] = product;
        _logger.e('Server rejected favorite status update');
      }
    } catch (e) {
      // Revert on error
      categoryProducts[productIndex] = product;
      _logger.e('Error updating favorite status: $e');
    }
  }

  // Clear search and reset to showing all products for current category
  void clearSearch() {
    if (isSearchActive.value && currentCategory.value != null) {
      searchQuery.value = '';
      isSearchActive.value = false;
      fetchCategoryProducts(currentCategory.value!.id);
    }
  }
  
  @override
  void onClose() {
    _logger.d("CategoryProductController closed");
    super.onClose();
  }
}