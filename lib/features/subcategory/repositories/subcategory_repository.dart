import 'package:logger/logger.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/product/models/product_model.dart';
import 'package:store_go/features/subcategory/models/subcategory_model.dart';

class SubcategoryRepository {
  final ApiClient _apiClient;
  final Logger _logger = Logger();

  SubcategoryRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<Subcategory>> getSubcategoriesByCategoryId(String categoryId) async {
    try {
      final response = await _apiClient.get('/subcategories/category/$categoryId');
      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((item) => Subcategory.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load subcategories: ${response.statusMessage}');
      }
    } catch (e) {
      _logger.e('Failed to load subcategories for category $categoryId: $e');
      throw Exception('Failed to load subcategories: $e');
    }
  }

  Future<List<Product>> getProductsBySubcategoryId(String subcategoryId) async {
    try {
      final response = await _apiClient.get('/subcategories/products/$subcategoryId');
      if (response.statusCode == 200) {
        final data = response.data['data']['products'] as List;
        return data.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load products for subcategory: ${response.statusMessage}');
      }
    } catch (e) {
      _logger.e('Failed to load products for subcategory $subcategoryId: $e');
      throw Exception('Failed to load products for subcategory: $e');
    }
  }

  Future<List<Subcategory>> getAllSubcategories() async {
    try {
      final response = await _apiClient.get('/subcategories');
      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((item) => Subcategory.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load all subcategories: ${response.statusMessage}');
      }
    } catch (e) {
      _logger.e('Failed to load all subcategories: $e');
      throw Exception('Failed to load all subcategories: $e');
    }
  }
}