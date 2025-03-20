import 'package:dio/dio.dart' as dio;
import 'package:logger/logger.dart';
import 'package:store_go/core/services/api/api_client.dart';

class CategoryApiService {
  final ApiClient _apiClient;

  // Dependency injection through constructor
  CategoryApiService(this._apiClient);

  // Get all categories method
  Future<dio.Response> getCategories() async {
    try {
      Logger().d("Getting categories");
      final categories = await _apiClient.get("/categories");
      Logger().d(categories.toString());
      return categories;
    } catch (e) {
      Logger().e("Error getting categories: $e");
      rethrow;
    }
  }

  // Get category by ID method
  Future<dio.Response> getCategoryById(int id) async {
    try {
      Logger().d("Getting category by ID: $id");
      final category = await _apiClient.get("/categories/$id");
      Logger().d(category.toString());
      return category;
    } catch (e) {
      Logger().e("Error getting category by ID: $id, $e");
      rethrow;
    }
  }
}
