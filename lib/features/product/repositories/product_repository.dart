import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/product/models/product_modal.dart';

class ProductRepository {
  final ApiClient _apiClient;

  // Constructor with dependency injection
  ProductRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  // Caching mechanism for products
  final Map<String, Product> _productCache = {};
  final Map<String, List<Product>> _categoryProductsCache = {};
  final List<Product> _allProductsCache = [];

  // Endpoint paths
  static const String _productsEndpoint = '/products';

  // Get all products with caching
  Future<List<Product>> getProducts({bool forceRefresh = false}) async {
    if (_allProductsCache.isEmpty || forceRefresh) {
      try {
        final response = await _apiClient.get(_productsEndpoint);

        if (response.statusCode == 200) {
          // Parse the response data into a list of Product objects
          List<dynamic> productsJson = response.data['data'] ?? [];
          final products =
              productsJson.map((json) => Product.fromJson(json)).toList();

          _allProductsCache.clear();
          _allProductsCache.addAll(products);

          // Update cache entries for individual products
          for (var product in products) {
            _productCache[product.id] = product;
          }

          return products;
        } else {
          throw Exception('Failed to load products: ${response.statusMessage}');
        }
      } catch (e) {
        throw Exception('Error fetching products: $e');
      }
    }

    return List.from(_allProductsCache);
  }

  // Get product by ID with caching
  Future<Product> getProductById(
    String productId, {
    bool forceRefresh = false,
  }) async {
    if (!_productCache.containsKey(productId) || forceRefresh) {
      try {
        final response = await _apiClient.get('$_productsEndpoint/$productId');

        if (response.statusCode == 200) {
          final product = Product.fromJson(response.data['data']);
          _productCache[productId] = product;
          return product;
        } else {
          throw Exception(
            'Failed to load product details: ${response.statusMessage}',
          );
        }
      } catch (e) {
        throw Exception('Error fetching product details: $e');
      }
    }

    return _productCache[productId]!;
  }

Future<List<Product>> getProductsByCategory(
    String categoryId, {
    bool forceRefresh = false,
  }) async {
    // Always clear the cached category products when forced to refresh
    if (forceRefresh && _categoryProductsCache.containsKey(categoryId)) {
      _categoryProductsCache.remove(categoryId);
    }
    
    if (!_categoryProductsCache.containsKey(categoryId) || forceRefresh) {
      try {
        // Ensure we're passing the categoryId to the API using the correct format
        final response = await _apiClient.get(
          '$_productsEndpoint/category/$categoryId',
          // If your API uses query parameters instead of path params, use this:
          // queryParameters: {'categoryId': categoryId},
        );

        if (response.statusCode == 200) {
          List<dynamic> productsJson = response.data['data'] ?? [];
          final products =
              productsJson.map((json) => Product.fromJson(json)).toList();

          // Important: Store these products specific to this category
          _categoryProductsCache[categoryId] = products;
          
          // Log the number of products

          // Also update individual product cache
          for (var product in products) {
            _productCache[product.id] = product;
          }

          return products;
        } else {
          throw Exception(
            'Failed to load category products: ${response.statusMessage}',
          );
        }
      } catch (e) {
        throw Exception('Error fetching category products: $e');
      }
    }

    // Return cached products for this category
    return List.from(_categoryProductsCache[categoryId] ?? []);
  }
  Future<List<Product>> getFeaturedProducts() async {
    try {
      final response = await _apiClient.get(
        _productsEndpoint,
        queryParameters: {'featured': 'true'},
      );

      if (response.statusCode == 200) {
        List<dynamic> productsJson = response.data['data'] ?? [];
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load featured products: ${response.statusMessage}',
        );
      }
    } catch (e) {
      // If your backend hasn't implemented filtering yet, fall back to all products
      return getProducts();
    }
  }

  // Get new products
  Future<List<Product>> getNewProducts() async {
    try {
      final response = await _apiClient.get(
        _productsEndpoint,
        queryParameters: {'sort': 'newest'},
      );

      if (response.statusCode == 200) {
        List<dynamic> productsJson = response.data['data'] ?? [];
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load new products: ${response.statusMessage}',
        );
      }
    } catch (e) {
      // If sorting isn't implemented yet, fall back to all products
      return getProducts();
    }
  }

  // Search products
  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await _apiClient.get(
        _productsEndpoint,
        queryParameters: {'search': query},
      );

      if (response.statusCode == 200) {
        List<dynamic> productsJson = response.data['data'] ?? [];
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search products: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error searching products: $e');
    }
  }

  // Update favorite status
  Future<bool> updateFavoriteStatus(String productId, bool isFavorite) async {
    try {
      final response = await _apiClient.put(
        '$_productsEndpoint/$productId/favorite',
        data: {'isFavorite': isFavorite},
      );

      final success = response.statusCode == 200;

      // Update cache if successful
      if (success && _productCache.containsKey(productId)) {
        _productCache[productId] = _productCache[productId]!.copyWith(
          isFavorite: isFavorite,
        );

        // Update in collections too
        _updateProductInCollections(productId, isFavorite);
      }

      return success;
    } catch (e) {
      // If API doesn't support it yet, return true to allow local state change
      return true;
    }
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
