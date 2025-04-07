
import 'package:get/get.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/product/models/product_modal.dart';

class ProductApiService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  // Endpoint paths - adjusted based on your API response
  static const String _productsEndpoint = '/products';

  // Fetch all products
  Future<List<Product>> fetchProducts() async {
    try {
      final response = await _apiClient.get(_productsEndpoint);

      // Check for successful response
      if (response.statusCode == 200) {
        // Parse the response data into a list of Product objects
        List<dynamic> productsJson = response.data['data'] ?? [];
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw 'Failed to load products: ${response.statusMessage}';
      }
    } catch (e) {
      // For development, it can be helpful to print the error
      print('Error in fetchProducts: $e');
      throw 'Error fetching products: $e';
    }
  }

  // Fetch products by category ID
  Future<List<Product>> fetchProductsByCategory(String categoryId) async {
    try {
      final response = await _apiClient.get(
        '$_productsEndpoint',
        queryParameters: {'categoryId': categoryId},
      );

      if (response.statusCode == 200) {
        List<dynamic> productsJson = response.data['data'] ?? [];
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw 'Failed to load category products: ${response.statusMessage}';
      }
    } catch (e) {
      throw 'Error fetching category products: $e';
    }
  }

  // Fetch product details by ID
  Future<Product> fetchProductById(String productId) async {
    try {
      final response = await _apiClient.get('$_productsEndpoint/$productId');

      if (response.statusCode == 200) {
        return Product.fromJson(response.data['data']);
      } else {
        throw 'Failed to load product details: ${response.statusMessage}';
      }
    } catch (e) {
      throw 'Error fetching product details: $e';
    }
  }

  // Fetch featured/top selling products - adjust endpoint if needed
  Future<List<Product>> fetchFeaturedProducts() async {
    try {
      final response = await _apiClient.get(
        '$_productsEndpoint',
        queryParameters: {'featured': 'true'},
      );

      if (response.statusCode == 200) {
        List<dynamic> productsJson = response.data['data'] ?? [];
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw 'Failed to load featured products: ${response.statusMessage}';
      }
    } catch (e) {
      // If your backend hasn't implemented filtering yet,
      // you can fall back to all products
      return fetchProducts();
    }
  }

  // Fetch new products
  Future<List<Product>> fetchNewProducts() async {
    try {
      final response = await _apiClient.get(
        '$_productsEndpoint',
        queryParameters: {'sort': 'newest'},
      );

      if (response.statusCode == 200) {
        List<dynamic> productsJson = response.data['data'] ?? [];
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw 'Failed to load new products: ${response.statusMessage}';
      }
    } catch (e) {
      // If sorting isn't implemented yet, fall back to all products
      return fetchProducts();
    }
  }

  // Search products
  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await _apiClient.get(
        '$_productsEndpoint',
        queryParameters: {'search': query},
      );

      if (response.statusCode == 200) {
        List<dynamic> productsJson = response.data['data'] ?? [];
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw 'Failed to search products: ${response.statusMessage}';
      }
    } catch (e) {
      throw 'Error searching products: $e';
    }
  }

  // Toggle favorite status (this may need to be a local operation if your API
  // doesn't support it yet)
  Future<bool> updateFavoriteStatus(String productId, bool isFavorite) async {
    try {
      // If your API supports this endpoint:
      final response = await _apiClient.put(
        '$_productsEndpoint/$productId/favorite',
        data: {'isFavorite': isFavorite},
      );

      return response.statusCode == 200;
    } catch (e) {
      // If API doesn't support it yet, return true to allow local state change
      print('Favorite toggle API not implemented: $e');
      return true;
    }
  }
}
