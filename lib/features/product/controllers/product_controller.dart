import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/product/models/product_model.dart';
import 'package:store_go/features/product/repositories/product_repository.dart';
import 'dart:developer' as developer;

class ProductController extends GetxController {
  final ProductRepository _repository;
  final Logger _logger = Logger();

  final RxList<Product> products = <Product>[].obs;
  final RxList<Product> featuredProducts = <Product>[].obs;
  final RxList<Product> newProducts = <Product>[].obs;
  final RxList<Product> searchResults = <Product>[].obs;
  final RxBool isLoadingAll = false.obs;
  final RxBool isLoadingFeatured = false.obs;
  final RxBool isLoadingNew = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  ProductController({required ProductRepository repository}) : _repository = repository;

  @override
  void onInit() {
    super.onInit();
    fetchAllProducts();
    fetchFeaturedProducts();
    fetchNewProducts();
  }

  Future<void> fetchAllProducts() async {
    try {
      isLoadingAll.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final fetchedProducts = await _repository.getProducts();
      products.assignAll(fetchedProducts);
      developer.log('Fetched ${fetchedProducts.length} products', name: 'ProductController.fetchAllProducts');
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load products. Please try again.';
      _logger.e('Error fetching products: $e');
      developer.log('Error fetching products: $e', name: 'ProductController.fetchAllProducts', error: e);
    } finally {
      isLoadingAll.value = false;
    }
  }

  Future<void> fetchProductsByCategory(String categoryId) async {
    try {
      isLoadingAll.value = true;
      hasError.value = false;

      if (categoryId.isEmpty) {
        await fetchAllProducts();
        return;
      }

      final categoryProducts = await _repository.getProductsByCategory(categoryId);
      products.assignAll(categoryProducts);
      developer.log('Fetched ${categoryProducts.length} products for category $categoryId',
          name: 'ProductController.fetchProductsByCategory');
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load category products. Please try again.';
      _logger.e('Error fetching products by category: $e');
      developer.log('Error fetching products by category: $e',
          name: 'ProductController.fetchProductsByCategory', error: e);
    } finally {
      isLoadingAll.value = false;
    }
  }

  Future<void> fetchProductsBySubcategory(String subcategoryId) async {
    try {
      isLoadingAll.value = true;
      hasError.value = false;
      errorMessage.value = '';

      if (subcategoryId.isEmpty) {
        await fetchAllProducts();
        return;
      }

      final subcategoryProducts = await _repository.getProductsBySubcategory(subcategoryId);
      products.assignAll(subcategoryProducts);
      developer.log('Fetched ${subcategoryProducts.length} products for subcategory $subcategoryId',
          name: 'ProductController.fetchProductsBySubcategory');
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load subcategory products. Please try again.';
      _logger.e('Error fetching products by subcategory: $e');
      developer.log('Error fetching products by subcategory: $e',
          name: 'ProductController.fetchProductsBySubcategory', error: e);
    } finally {
      isLoadingAll.value = false;
    }
  }

  Future<void> fetchFeaturedProducts() async {
    try {
      isLoadingFeatured.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final featured = await _repository.getFeaturedProducts();
      featuredProducts.assignAll(featured);
      developer.log('Fetched ${featured.length} featured products', name: 'ProductController.fetchFeaturedProducts');
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load featured products. Please try again.';
      _logger.e('Error fetching featured products: $e');
      developer.log('Error fetching featured products: $e',
          name: 'ProductController.fetchFeaturedProducts', error: e);
    } finally {
      isLoadingFeatured.value = false;
    }
  }

  Future<void> fetchNewProducts() async {
    try {
      isLoadingNew.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final newItems = await _repository.getNewProducts();
      newProducts.assignAll(newItems);
      developer.log('Fetched ${newItems.length} new products', name: 'ProductController.fetchNewProducts');
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load new products. Please try again.';
      _logger.e('Error fetching new products: $e');
      developer.log('Error fetching new products: $e', name: 'ProductController.fetchNewProducts', error: e);
    } finally {
      isLoadingNew.value = false;
    }
  }

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    try {
      isLoadingAll.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final results = await _repository.searchProducts(query);
      searchResults.assignAll(results);
      developer.log('Found ${results.length} products for query: $query', name: 'ProductController.searchProducts');
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to search products. Please try again.';
      _logger.e('Error searching products: $e');
      developer.log('Error searching products: $e', name: 'ProductController.searchProducts', error: e);
    } finally {
      isLoadingAll.value = false;
    }
  }

  Future<void> toggleFavorite(String productId) async {
    _toggleFavoriteInList(products, productId);
    _toggleFavoriteInList(featuredProducts, productId);
    _toggleFavoriteInList(newProducts, productId);
    _toggleFavoriteInList(searchResults, productId);

    bool? newFavoriteStatus;
    for (var list in [products, featuredProducts, newProducts, searchResults]) {
      final index = list.indexWhere((p) => p.id == productId);
      if (index != -1) {
        newFavoriteStatus = list[index].isFavorite;
        break;
      }
    }

    if (newFavoriteStatus == null) return;

    try {
      final success = await _repository.updateFavoriteStatus(productId, newFavoriteStatus);
      if (!success) {
        _revertFavoriteChange(productId, !newFavoriteStatus);
      }
      developer.log('Updated favorite status for product $productId to $newFavoriteStatus',
          name: 'ProductController.toggleFavorite');
    } catch (e) {
      _revertFavoriteChange(productId, !newFavoriteStatus);
      _logger.e('Error updating favorite status: $e');
      developer.log('Error updating favorite status: $e',
          name: 'ProductController.toggleFavorite', error: e);
    }
  }

  void _toggleFavoriteInList(RxList<Product> productList, String productId) {
    final index = productList.indexWhere((p) => p.id == productId);
    if (index != -1) {
      final product = productList[index];
      productList[index] = product.copyWith(isFavorite: !product.isFavorite);
    }
  }

  void _revertFavoriteChange(String productId, bool originalState) {
    for (var list in [products, featuredProducts, newProducts, searchResults]) {
      final index = list.indexWhere((p) => p.id == productId);
      if (index != -1) {
        final product = list[index];
        list[index] = product.copyWith(isFavorite: originalState);
      }
    }
  }

  Future<void> clearFilters() async {
    try {
      isLoadingAll.value = true;
      hasError.value = false;
      errorMessage.value = '';

      await fetchAllProducts();
      developer.log('Cleared filters and fetched all products', name: 'ProductController.clearFilters');
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to clear filters. Please try again.';
      _logger.e('Error clearing filters: $e');
      developer.log('Error clearing filters: $e', name: 'ProductController.clearFilters', error: e);
    } finally {
      isLoadingAll.value = false;
    }
  }

  Future<void> filterProducts({
    String? category,
    String? subcategory,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    int? rating,
  }) async {
    try {
      isLoadingAll.value = true;
      hasError.value = false;
      errorMessage.value = '';

      if (products.isEmpty) {
        await fetchAllProducts();
      }

      List<Product> filteredProducts = List.from(products);

      if (category != null && category != 'All') {
        filteredProducts = filteredProducts.where((p) => p.category == category).toList();
      }

      if (subcategory != null && subcategory.isNotEmpty) {
        filteredProducts = filteredProducts.where((p) => p.subcategory == subcategory).toList();
      }

      if (minPrice != null && maxPrice != null) {
        filteredProducts =
            filteredProducts.where((p) => p.price >= minPrice && p.price <= maxPrice).toList();
      }

      if (rating != null && rating > 0) {
        filteredProducts = filteredProducts.where((p) => p.rating >= rating).toList();
      }

      if (sortBy != null) {
        switch (sortBy) {
          case 'Latest':
          case 'New Today':
            filteredProducts.sort((a, b) => b.id.compareTo(a.id));
            break;
          case 'Top Sellers':
            filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
            break;
          case 'New collection':
            filteredProducts.sort((a, b) => b.id.compareTo(a.id));
            break;
        }
      }

      products.assignAll(filteredProducts);
      developer.log(
          'Filtered ${filteredProducts.length} products with criteria: '
          'category=$category, subcategory=$subcategory, minPrice=$minPrice, '
          'maxPrice=$maxPrice, sortBy=$sortBy, rating=$rating',
          name: 'ProductController.filterProducts');
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to apply filters. Please try again.';
      _logger.e('Error applying filters: $e');
      developer.log('Error applying filters: $e', name: 'ProductController.filterProducts', error: e);
    } finally {
      isLoadingAll.value = false;
    }
  }
}