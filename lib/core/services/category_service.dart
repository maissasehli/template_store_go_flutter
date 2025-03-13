import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:store_go/core/model/home/category_model.dart';

class CategoryService {
  final String baseUrl = 'https://your-api-endpoint.com/api';

  // Get all categories
  Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      // For demo, return dummy categories
      return _getDummyCategories();
    }
  }

  // Dummy categories for demo - updated to match reference image
  List<Category> _getDummyCategories() {
    return [
      Category(
        id: 'hoodies',
        name: 'Hoodies',
        icon: 'assets/categories/category_hoodies.png', 
      ),
      Category(
        id: 'shorts',
        name: 'Shorts',
        icon: 'assets/categories/category_shorts.png', 
      ),
      Category(
        id: 'shoes',
        name: 'Shoes',
        icon: 'assets/categories/category_shoes.png', 
      ),
      Category(
        id: 'bag',
        name: 'Bag',
        icon: 'assets/categories/category_bag.png', 
      ),
      Category(
        id: 'accessories',
        name: 'Accessories',
        icon:
            'assets/categories/category_accessories.png', 
      ),
    ];
  }
}
