import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/product/models/product_model.dart';
import 'package:store_go/features/product/repositories/product_repository.dart';
import 'package:store_go/features/product/state/product_list_state.dart';

/// Controller responsible for managing product listings
class ProductListController extends GetxController {
  final ProductRepository _repository;
  final ProductListState state = ProductListState();
  final Logger _logger = Logger();

  ProductListController({required ProductRepository repository})
    : _repository = repository;
  @override
  void onInit() {
    super.onInit();
    fetchAllProducts();
    fetchFeaturedProducts();
    fetchNewProducts();
  }

  /// Fetches all products from the repository
  Future<void> fetchAllProducts() async {
    try {
      state.setLoading(true);
      state.clearError();

      final fetchedProducts = await _repository.getProducts(
        forceRefresh: true,
      );
      state.setProducts(fetchedProducts);
    } catch (e) {
      state.setError('Error fetching products: $e');
      _logger.e('Error fetching products: $e');
    } finally {
      state.setLoading(false);
    }
  }

  /// Fetches products by category ID
  Future<void> fetchProductsByCategory(String categoryId) async {
    try {
      state.setLoading(true);
      state.clearError();

      if (categoryId.isEmpty) {
        // If no category selected, show all products
        await fetchAllProducts();
        return;
      }

      final categoryProducts = await _repository.getProductsByCategory(
        categoryId,
        forceRefresh: true,
      );
      state.setProducts(categoryProducts);
    } catch (e) {
      state.setError('Error fetching products by category: $e');
      _logger.e('Error fetching products by category: $e');
    } finally {
      state.setLoading(false);
    }
  }

  /// Fetches featured products
  Future<void> fetchFeaturedProducts() async {
    try {
      final featured = await _repository.getFeaturedProducts();
      state.setFeaturedProducts(featured);
    } catch (e) {
      _logger.e('Error fetching featured products: $e');
      // If featured fails, we can still show other sections
    }
  }

  /// Fetches new products
  Future<void> fetchNewProducts() async {
    try {
      final newItems = await _repository.getNewProducts();
      state.setNewProducts(newItems);
    } catch (e) {
      _logger.e('Error fetching new products: $e');
      // If new products fail, we can still show other sections
    }
  }

  /// Searches products based on query string
  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      state.clearSearchResults();
      return;
    }

    try {
      state.setLoading(true);
      final results = await _repository.searchProducts(query);
      state.setSearchResults(results);
    } catch (e) {
      _logger.e('Error searching products: $e');
    } finally {
      state.setLoading(false);
    }
  }

  /// Clears all filters and resets to original products state
  Future<void> clearFilters() async {
    try {
      state.setLoading(true);
      // Fetch all products without filters
      await fetchAllProducts();
    } catch (e) {
      state.setError('Error clearing filters: $e');
      _logger.e('Error clearing filters: $e');
    } finally {
      state.setLoading(false);
    }
  }

  /// Filters products based on provided criteria
  Future<void> filterProducts({
    String? category,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    int? rating,
  }) async {
    try {
      state.setLoading(true);
      state.clearError();

      // Start with all products (or you could optimize by fetching filtered results from API)
      // First get all products if we don't have them yet
      if (state.products.isEmpty) {
        await fetchAllProducts();
      }

      // Create a copy to filter
      List<Product> filteredProducts = List.from(state.products);

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
          case 'NewToday':
            // Assuming newer products have higher IDs or another property
            filteredProducts.sort((a, b) => b.id.compareTo(a.id));
            break;
          case 'TopSellers':
            // Assuming you track sales or popularity - here using rating as a proxy
            filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
            break;
          case 'Newcollection':
            // This might be based on a specific category or tag
            filteredProducts.sort((a, b) => b.id.compareTo(a.id));
            break;
        }
      }

      // Update the products list with filtered results
      state.setProducts(filteredProducts);
    } catch (e) {
      state.setError('Error applying filters: $e');
      _logger.e('Error applying filters: $e');
    } finally {
      state.setLoading(false);
    }
  }
}
