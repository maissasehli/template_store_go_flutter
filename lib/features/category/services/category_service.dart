import 'package:dio/dio.dart' as dio;
import 'package:store_go/features/category/services/category_api_service.dart';
import 'package:store_go/features/home/models/category_model.dart';
import 'package:logger/logger.dart';

class CategoryService {
  final CategoryApiService _categoryApiService;
  final Logger _logger = Logger();

  // Dependency injection through constructor
  CategoryService(this._categoryApiService);

  // Get all categories
Future<List<Category>> getCategories() async {
    try {
      // Use the API service to get categories
      final dio.Response response = await _categoryApiService.getCategories();

      if (response.statusCode == 200) {
        _logger.d("Categories fetched successfully");

        // The response.data is a Map with a "data" key containing the list of categories
        final Map<String, dynamic> responseMap = response.data;

        // Extract the categories list from the "data" key
        final List<dynamic> categoriesJson = responseMap['data'];

        return categoriesJson.map((json) => Category.fromJson(json)).toList();
      } else {
        _logger.e("Failed to load categories: ${response.statusCode}");
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e("Error fetching categories: $e");
      throw Exception('Error fetching categories: $e');
    }
  }

  // Get category by ID
  Future<Category> getCategoryById(String id) async {
    try {
      // Use the API service to get a category by ID
      final dio.Response response = await _categoryApiService.getCategoryById(
        int.parse(id),
      );

      if (response.statusCode == 200) {
        _logger.d("Category with ID $id fetched successfully");
        return Category.fromJson(response.data);
      } else {
        _logger.e("Failed to load category: ${response.statusCode}");
        throw Exception('Failed to load category: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e("Error fetching category with ID $id: $e");
      throw Exception('Error fetching category with ID $id: $e');
    }
  }
}
