import 'package:store_go/app/core/services/api_client.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/category/models/category.modal.dart';

class CategoryRepository {
  final ApiClient _apiClient;
  final Logger _logger = Logger();

  CategoryRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<Category>> getCategories() async {
    try {
      final response = await _apiClient.get('/categories');

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((item) => Category.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      _logger.e('Failed to load categories: $e');
      throw Exception('Failed to load categories: $e');
    }
  }

  // Add additional methods as needed, for example:
  Future<Category> getCategoryById(String id) async {
    try {
      final response = await _apiClient.get('/categories/$id');

      if (response.statusCode == 200) {
        return Category.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to load category details');
      }
    } catch (e) {
      _logger.e('Failed to load category details: $e');
      throw Exception('Failed to load category details: $e');
    }
  }
}
