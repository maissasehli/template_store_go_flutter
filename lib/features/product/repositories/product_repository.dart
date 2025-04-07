import 'package:store_go/features/product/models/product_modal.dart';
import 'package:store_go/features/product/services/product_service.dart';

class ProductRepository {
  final ProductService _productService;

  ProductRepository(this._productService);

  // Caching mechanism for products
  final Map<String, Product> _productCache = {};
  final Map<String, List<Product>> _categoryProductsCache = {};
  final List<Product> _allProductsCache = [];

  // Get all products with caching
  Future<List<Product>> getAllProducts({bool forceRefresh = false}) async {
    if (_allProductsCache.isEmpty || forceRefresh) {
      final products = await _productService.getProducts();
      _allProductsCache.clear();
      _allProductsCache.addAll(products);

      // Update cache entries for individual products
      for (var product in products) {
        _productCache[product.id] = product;
      }
    }
    return _allProductsCache;
  }

  // Get product by ID with caching
  Future<Product> getProductById(
    String productId, {
    bool forceRefresh = false,
  }) async {
    if (!_productCache.containsKey(productId) || forceRefresh) {
      final product = await _productService.getProductById(productId);
      _productCache[productId] = product;
    }
    return _productCache[productId]!;
  }

  // Get products by category with caching
  Future<List<Product>> getProductsByCategory(
    String categoryId, {
    bool forceRefresh = false,
  }) async {
    if (!_categoryProductsCache.containsKey(categoryId) || forceRefresh) {
      final products = await _productService.getProductsByCategory(categoryId);
      _categoryProductsCache[categoryId] = products;

      // Update cache entries for individual products
      for (var product in products) {
        _productCache[product.id] = product;
      }
    }
    return _categoryProductsCache[categoryId] ?? [];
  }

  // Get featured products
  Future<List<Product>> getFeaturedProducts() async {
    return await _productService.getFeaturedProducts();
  }

  // Get new products
  Future<List<Product>> getNewProducts() async {
    return await _productService.getNewProducts();
  }

  // Search products
  Future<List<Product>> searchProducts(String query) async {
    return await _productService.searchProducts(query);
  }

  // Update favorite status
  Future<bool> updateFavoriteStatus(String productId, bool isFavorite) async {
    final success = await _productService.updateFavoriteStatus(
      productId,
      isFavorite,
    );

    // Update cache if successful
    if (success && _productCache.containsKey(productId)) {
      _productCache[productId] = _productCache[productId]!.copyWith(
        isFavorite: isFavorite,
      );

      // Update in collections too
      _updateProductInCollections(productId, isFavorite);
    }

    return success;
  }

  // Update product in all cached collections
  void _updateProductInCollections(String productId, bool isFavorite) {
    // Update in all products cache
    final allProductIndex = _allProductsCache.indexWhere(
      (p) => p.id == productId,
    );
    if (allProductIndex != -1) {
      _allProductsCache[allProductIndex] = _allProductsCache[allProductIndex]
          .copyWith(isFavorite: isFavorite);
    }

    // Update in category caches
    for (var entry in _categoryProductsCache.entries) {
      final index = entry.value.indexWhere((p) => p.id == productId);
      if (index != -1) {
        entry.value[index] = entry.value[index].copyWith(
          isFavorite: isFavorite,
        );
      }
    }
  }

  // Clear all caches
  void clearCache() {
    _productCache.clear();
    _categoryProductsCache.clear();
    _allProductsCache.clear();
  }
}
