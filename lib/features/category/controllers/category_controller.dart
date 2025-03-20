import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/product/controllers/product_controller.dart';
import 'package:store_go/features/home/models/category_model.dart';
import 'package:store_go/features/category/services/category_service.dart';
import 'package:store_go/features/product/views/category_products_screen.dart';

class CategoryController extends GetxController {
  final CategoryService _categoryService = CategoryService();
  
  // Observable variables
  final RxList<Category> categories = <Category>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedCategoryId = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }
  
  // Fetch all categories
  Future<void> fetchCategories() async {
    isLoading(true);
    try {
      final result = await _categoryService.getCategories();
      categories.value = result;
      
      // Select first category by default if none selected
      if (selectedCategoryId.isEmpty && categories.isNotEmpty) {
        selectedCategoryId.value = categories.first.id;
      }
    } catch (e) {
      Get.snackbar(
        'Error', 
        'Failed to load categories',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        duration: const Duration(seconds: 3),
      );
      print('Error fetching categories: $e');
    } finally {
      isLoading(false);
    }
  }
  
  // Set selected category and navigate to products screen
  void selectCategory(String categoryId) {
    selectedCategoryId.value = categoryId;
    
    // Find the category object
    final category = categories.firstWhere(
      (cat) => cat.id == categoryId,
      orElse: () => categories.isNotEmpty ? categories.first : Category(id: '', name: 'Unknown'),
    );
    
    // Navigate to CategoryProductsScreen with the selected category
    Get.to(() => const CategoryProductsScreen(), arguments: category);
    
    // Also update the product controller for when we arrive at the screen
    final ProductController productController = Get.find<ProductController>();
    productController.fetchProductsByCategory(categoryId);
  }
  
  // Get selected category
  Category? get selectedCategory {
    if (selectedCategoryId.isEmpty || categories.isEmpty) return null;
    
    final index = categories.indexWhere((category) => category.id == selectedCategoryId.value);
    if (index >= 0) {
      return categories[index];
    }
    return null;
  }
}