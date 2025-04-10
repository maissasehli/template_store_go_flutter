import 'package:dio/dio.dart' as dio;
import 'package:logger/logger.dart';
import 'package:store_go/app/core/services/api_client.dart';

class ProductApiService {
  final ApiClient _apiClient;
  final Logger _logger = Logger();

  ProductApiService(this._apiClient);

  /// Fetch all products without pagination.
  Future<dio.Response> getAllProducts({
    String? categoryId,
    String? searchQuery,
  }) async {
    try {
      Map<String, dynamic> queryParams = {};

      if (categoryId != null && categoryId.isNotEmpty) {
        queryParams['categoryId'] = categoryId;
      }

      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams['search'] = searchQuery;
      }

      final response = await _apiClient.get('/products', queryParameters: queryParams);
      return response;
    } catch (e) {
      _logger.e('Error fetching all products: $e');
      rethrow;
    }
  }

  /// Fetch all categories.
  Future<dio.Response> getCategories() async {
    try {
      final response = await _apiClient.get('/categories');
      return response;
    } catch (e) {
      _logger.e('Error fetching categories: $e');
      rethrow;
    }
  }

  /// Fetch a single product by its ID.
  Future<dio.Response> getProductById(String id) async {
    try {
      final response = await _apiClient.get('/products/$id');
      return response;
    } catch (e) {
      _logger.e('Error fetching product by ID: $e');
      rethrow;
    }
  }

  /// Update product fields by ID.
  Future<dio.Response> updateProduct(String productId, Map<String, bool> updateData) async {
    try {
      final response = await _apiClient.patch(
        '/products/$productId', 
        data: updateData,
      );
      return response;
    } catch (e) {
      _logger.e('Error updating product: $e');
      rethrow;
    }
  }

  /// Fetch products by category using a specific endpoint.
  Future<dio.Response> getProductsByCategory(
    String categoryId, {
    int page = 1,
    int limit = 50, // Default high limit to get more items
    String? searchQuery,
  }) async {
    try {
      Map<String, dynamic> queryParams = {
        'categoryId': categoryId,
        'page': page,
        'limit': limit,
      };

      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams['search'] = searchQuery;
      }


      final response = await _apiClient.get(
        '/products/category/$categoryId',
        queryParameters: queryParams,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Toggle favorite status of a product.
  Future<dio.Response> toggleFavorite(String productId, bool isFavorite) async {
    try {
      final response = await updateProduct(productId, {
        'isFavorite': isFavorite,
      });
      return response;
    } catch (e) {
      _logger.e('Error toggling favorite: $e');
      rethrow;
    }
  }
}
