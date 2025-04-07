import 'package:get/get.dart';
import 'package:store_go/features/product/models/product_modal.dart';
import 'package:store_go/features/product/services/product_api_service.dart';

class ProductService {
  final ProductApiService _apiService = Get.put(ProductApiService());

  // Get all products
  Future<List<Product>> getProducts() async {
    try {
      return await _apiService.fetchProducts();
    } catch (e) {
      // If API fails, we could return empty list or rethrow based on error handling strategy
      rethrow;
    }
  }

  // Get products by category
  Future<List<Product>> getProductsByCategory(String categoryId) async {
    try {
      return await _apiService.fetchProductsByCategory(categoryId);
    } catch (e) {
      rethrow;
    }
  }

  // Get product by ID
  Future<Product> getProductById(String productId) async {
    try {
      return await _apiService.fetchProductById(productId);
    } catch (e) {
      rethrow;
    }
  }

  // Get featured products
  Future<List<Product>> getFeaturedProducts() async {
    try {
      return await _apiService.fetchFeaturedProducts();
    } catch (e) {
      rethrow;
    }
  }

  // Get new products
  Future<List<Product>> getNewProducts() async {
    try {
      return await _apiService.fetchNewProducts();
    } catch (e) {
      rethrow;
    }
  }

  // Search products
  Future<List<Product>> searchProducts(String query) async {
    try {
      return await _apiService.searchProducts(query);
    } catch (e) {
      rethrow;
    }
  }

  // Update favorite status
  Future<bool> updateFavoriteStatus(String productId, bool isFavorite) async {
    try {
      return await _apiService.updateFavoriteStatus(productId, isFavorite);
    } catch (e) {
      rethrow;
    }
  }
}
