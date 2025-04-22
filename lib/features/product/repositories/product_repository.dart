import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/product/models/product_model.dart';
import 'package:store_go/features/review/model/review_model.dart';
import 'dart:developer' as developer;

class ProductRepository {
  final ApiClient _apiClient;

  ProductRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final Map<String, Product> _productCache = {};
  final Map<String, List<Product>> _categoryProductsCache = {};
  final List<Product> _allProductsCache = [];

  static const String _productsEndpoint = '/products';

  Future<List<Product>> getProducts({bool forceRefresh = false}) async {
    if (_allProductsCache.isEmpty || forceRefresh) {
      try {
        final response = await _apiClient.get(_productsEndpoint);
        developer.log('Get products response: ${response.data}', name: 'ProductRepository.getProducts');

        if (response.statusCode == 200) {
          List<dynamic> productsJson = response.data['data'] ?? [];
          final products = productsJson.map((json) => Product.fromJson(json)).toList();

          _allProductsCache.clear();
          _allProductsCache.addAll(products);

          for (var product in products) {
            _productCache[product.id] = product;
          }

          return products;
        } else {
          throw Exception('Failed to load products: ${response.statusMessage}');
        }
      } catch (e) {
        developer.log('Error fetching products: $e', name: 'ProductRepository.getProducts', error: e);
        throw Exception('Error fetching products: $e');
      }
    }
    return List.from(_allProductsCache);
  }

  Future<Product> getProductById(String productId, {bool forceRefresh = false}) async {
    if (!_productCache.containsKey(productId) || forceRefresh) {
      try {
        final response = await _apiClient.get('$_productsEndpoint/$productId');
        developer.log('Get product by ID response: ${response.data}', name: 'ProductRepository.getProductById');

        if (response.statusCode == 200) {
          final product = Product.fromJson(response.data['data']);
          _productCache[productId] = product;
          return product;
        } else {
          throw Exception('Failed to load product: ${response.statusMessage}');
        }
      } catch (e) {
        developer.log('Error fetching product: $e', name: 'ProductRepository.getProductById', error: e);
        throw Exception('Error fetching product: $e');
      }
    }
    return _productCache[productId]!;
  }

  Future<List<Product>> getProductsByCategory(String categoryId, {bool forceRefresh = false}) async {
    if (!_categoryProductsCache.containsKey(categoryId) || forceRefresh) {
      try {
        final response = await _apiClient.get('$_productsEndpoint?category_id=$categoryId');
        developer.log('Get products by category response: ${response.data}', name: 'ProductRepository.getProductsByCategory');

        if (response.statusCode == 200) {
          List<dynamic> productsJson = response.data['data'] ?? [];
          final products = productsJson.map((json) => Product.fromJson(json)).toList();

          _categoryProductsCache[categoryId] = products;

          for (var product in products) {
            _productCache[product.id] = product;
          }

          return products;
        } else {
          throw Exception('Failed to load category products: ${response.statusMessage}');
        }
      } catch (e) {
        developer.log('Error fetching category products: $e', name: 'ProductRepository.getProductsByCategory', error: e);
        throw Exception('Error fetching category products: $e');
      }
    }
    return List.from(_categoryProductsCache[categoryId] ?? []);
  }

  Future<List<Product>> getProductsBySubcategory(String subcategoryId, {bool forceRefresh = false}) async {
    if (!_categoryProductsCache.containsKey(subcategoryId) || forceRefresh) {
      try {
        final response = await _apiClient.get('$_productsEndpoint?subcategory_id=$subcategoryId');
        developer.log('Get products by subcategory response: ${response.data}', name: 'ProductRepository.getProductsBySubcategory');

        if (response.statusCode == 200) {
          List<dynamic> productsJson = response.data['data'] ?? [];
          final products = productsJson.map((json) => Product.fromJson(json)).toList();

          _categoryProductsCache[subcategoryId] = products;

          for (var product in products) {
            _productCache[product.id] = product;
          }

          return products;
        } else {
          throw Exception('Failed to load subcategory products: ${response.statusMessage}');
        }
      } catch (e) {
        developer.log('Error fetching subcategory products: $e', name: 'ProductRepository.getProductsBySubcategory', error: e);
        throw Exception('Error fetching subcategory products: $e');
      }
    }
    return List.from(_categoryProductsCache[subcategoryId] ?? []);
  }

  Future<List<Product>> getFilteredProducts({
    String? categoryId,
    String? subcategoryId,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? sortOption,
    bool forceRefresh = false,
  }) async {
    try {
      final queryParameters = <String, String>{};
      if (categoryId != null) queryParameters['category_id'] = categoryId;
      if (subcategoryId != null) queryParameters['subcategory_id'] = subcategoryId;
      if (minPrice != null) queryParameters['min_price'] = minPrice.toString();
      if (maxPrice != null) queryParameters['max_price'] = maxPrice.toString();
      if (minRating != null) queryParameters['min_rating'] = minRating.toString();
      if (sortOption != null) {
        switch (sortOption) {
          case 'New Today':
            queryParameters['sort'] = 'created_at_desc';
            break;
          case 'Top Sellers':
            queryParameters['sort'] = 'sales_count_desc';
            break;
          case 'Price: Low to High':
            queryParameters['sort'] = 'price_asc';
            break;
          case 'Price: High to Low':
            queryParameters['sort'] = 'price_desc';
            break;
        }
      }

      final cacheKey = queryParameters.toString();
      if (!_categoryProductsCache.containsKey(cacheKey) || forceRefresh) {
        final response = await _apiClient.get(_productsEndpoint, queryParameters: queryParameters);
        developer.log('Get filtered products response: ${response.data}', name: 'ProductRepository.getFilteredProducts');

        if (response.statusCode == 200) {
          List<dynamic> productsJson = response.data['data'] ?? [];
          final products = productsJson.map((json) => Product.fromJson(json)).toList();

          _categoryProductsCache[cacheKey] = products;

          for (var product in products) {
            _productCache[product.id] = product;
          }

          return products;
        } else {
          throw Exception('Failed to load filtered products: ${response.statusMessage}');
        }
      }
      return List.from(_categoryProductsCache[cacheKey] ?? []);
    } catch (e) {
      developer.log('Error fetching filtered products: $e', name: 'ProductRepository.getFilteredProducts', error: e);
      throw Exception('Error fetching filtered products: $e');
    }
  }

  Future<List<Product>> getFeaturedProducts() async {
    try {
      final response = await _apiClient.get(_productsEndpoint, queryParameters: {'featured': 'true'});
      developer.log('Get featured products response: ${response.data}', name: 'ProductRepository.getFeaturedProducts');

      if (response.statusCode == 200) {
        List<dynamic> productsJson = response.data['data'] ?? [];
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load featured products: ${response.statusMessage}');
      }
    } catch (e) {
      developer.log('Error fetching featured products: $e', name: 'ProductRepository.getFeaturedProducts', error: e);
      return getProducts();
    }
  }

  Future<List<Product>> getNewProducts() async {
    try {
      final response = await _apiClient.get(_productsEndpoint, queryParameters: {'sort': 'created_at_desc'});
      developer.log('Get new products response: ${response.data}', name: 'ProductRepository.getNewProducts');

      if (response.statusCode == 200) {
        List<dynamic> productsJson = response.data['data'] ?? [];
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load new products: ${response.statusMessage}');
      }
    } catch (e) {
      developer.log('Error fetching new products: $e', name: 'ProductRepository.getNewProducts', error: e);
      return getProducts();
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await _apiClient.get(_productsEndpoint, queryParameters: {'search': query});
      developer.log('Search products response: ${response.data}', name: 'ProductRepository.searchProducts');

      if (response.statusCode == 200) {
        List<dynamic> productsJson = response.data['data'] ?? [];
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search products: ${response.statusMessage}');
      }
    } catch (e) {
      developer.log('Error searching products: $e', name: 'ProductRepository.searchProducts', error: e);
      throw Exception('Error searching products: $e');
    }
  }

  Future<bool> updateFavoriteStatus(String productId, bool isFavorite) async {
    try {
      final response = await _apiClient.put(
        '$_productsEndpoint/$productId/favorite',
        data: {'isFavorite': isFavorite},
      );
      developer.log('Update favorite status response: ${response.data}', name: 'ProductRepository.updateFavoriteStatus');

      final success = response.statusCode == 200;

      if (success && _productCache.containsKey(productId)) {
        _productCache[productId] = _productCache[productId]!.copyWith(isFavorite: isFavorite);
        _updateProductInCollections(productId, isFavorite: isFavorite);
      }

      return success;
    } catch (e) {
      developer.log('Error updating favorite status: $e', name: 'ProductRepository.updateFavoriteStatus', error: e);
      return false; // Changed to false to indicate failure
    }
  }

  Future<void> updateProductReviews(String productId, List<Review> reviews) async {
    try {
      final response = await _apiClient.put(
        '$_productsEndpoint/$productId',
        data: {
          'reviews': reviews.map((r) => r.toJson()).toList(),
        },
      );
      developer.log('Update product reviews response: ${response.data}', name: 'ProductRepository.updateProductReviews');

      if (response.statusCode == 200) {
        if (_productCache.containsKey(productId)) {
          _productCache[productId] = _productCache[productId]!.copyWith(reviews: reviews);
          _updateProductReviewsInCollections(productId, reviews);
        }
      } else {
        throw Exception('Failed to update product reviews: ${response.statusMessage}');
      }
    } catch (e) {
      developer.log('Error updating product reviews: $e', name: 'ProductRepository.updateProductReviews', error: e);
      throw Exception('Error updating product reviews: $e');
    }
  }

  void _updateProductInCollections(String productId, {bool? isFavorite, List<Review>? reviews}) {
    final allProductIndex = _allProductsCache.indexWhere((p) => p.id == productId);
    if (allProductIndex != -1) {
      _allProductsCache[allProductIndex] = _allProductsCache[allProductIndex].copyWith(
        isFavorite: isFavorite ?? _allProductsCache[allProductIndex].isFavorite,
        reviews: reviews ?? _allProductsCache[allProductIndex].reviews,
      );
    }

    for (var entry in _categoryProductsCache.entries) {
      final index = entry.value.indexWhere((p) => p.id == productId);
      if (index != -1) {
        entry.value[index] = entry.value[index].copyWith(
          isFavorite: isFavorite ?? entry.value[index].isFavorite,
          reviews: reviews ?? entry.value[index].reviews,
        );
      }
    }
  }

  void _updateProductReviewsInCollections(String productId, List<Review> reviews) {
    _updateProductInCollections(productId, reviews: reviews);
  }

  void clearCache() {
    _productCache.clear();
    _categoryProductsCache.clear();
    _allProductsCache.clear();
  }
}