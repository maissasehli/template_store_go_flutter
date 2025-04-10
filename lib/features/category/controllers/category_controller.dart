// File: category_controller.dart
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:store_go/features/category/services/category_api_service.dart';
import 'package:store_go/features/category/models/categories_model.dart';
import 'package:store_go/features/product/models/product_model.dart';

// Abstract class defining the contract for category controllers
abstract class CategoryController extends GetxController {
  // Abstract getters
  RxList<CategoriesModels> get categories;
  Rx<CategoriesModels?> get selectedCategory;
  RxBool get isLoading;
  RxString get searchQuery;
  RxList<CategoriesModels> get filteredCategories;
  RxList<ProductModels> get categoryProducts;
  RxString get selectedCategoryId;
  void gotoProduct({required List<CategoriesModels> categories, required String selectedCategoryId});

  
  // Abstract methods
  Future<void> fetchCategories();
  void selectCategory(String categoryId);
  void searchCategories(String query);
}

// Implementation of the abstract CategoryController
class CategoryControllerImp extends CategoryController {
  final CategoryApiService _apiService;
  final Logger _logger = Logger();
  
  // Observable variables
  final RxList<CategoriesModels> _categories = <CategoriesModels>[].obs;
  final Rx<CategoriesModels?> _selectedCategory = Rx<CategoriesModels?>(null);
  final RxBool _isLoading = false.obs;
  final RxString _searchQuery = ''.obs;
  
  // Filtered categories based on search
  final RxList<CategoriesModels> _filteredCategories = <CategoriesModels>[].obs;
  
  // Filtered products within a category
  final RxList<ProductModels> _categoryProducts = <ProductModels>[].obs;
  
  // Getters implementation
  @override
  RxList<CategoriesModels> get categories => _categories;
  
  @override
  Rx<CategoriesModels?> get selectedCategory => _selectedCategory;
  
  @override
  RxBool get isLoading => _isLoading;
  
  @override
  RxString get searchQuery => _searchQuery;
  
  @override
  RxList<CategoriesModels> get filteredCategories => _filteredCategories;
  
  @override
  RxList<ProductModels> get categoryProducts => _categoryProducts;
  
  @override
  RxString get selectedCategoryId => RxString(_selectedCategory.value?.id ?? '');
  
  CategoryControllerImp(this._apiService);
  
  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }
  
  @override
  Future<void> fetchCategories() async {
    try {
      _isLoading.value = true;
      final response = await _apiService.getCategories();
      final List<dynamic> categoriesData = response.data['data'] ?? [];
      _categories.value = categoriesData.map((json) => CategoriesModels.fromJson(json)).toList();
      
      // Initialize filtered categories with all categories
      _filteredCategories.value = List.from(_categories);
      
      // Set first category as default if categories exist
      if (_categories.isNotEmpty) {
        _selectedCategory.value = _categories.first;
      }
    } catch (e) {
      _logger.e('Error fetching categories: $e');
      // Fallback to dummy data if needed
      if (_categories.isNotEmpty) {
        _selectedCategory.value = _categories.first;
      }
    } finally {
      _isLoading.value = false;
    }
  }
  
  @override
  void selectCategory(String categoryId) {
    try {
      final category = _categories.firstWhere((cat) => cat.id == categoryId);
      _selectedCategory.value = category;
    } catch (e) {
      _logger.e('Error selecting category: $e');
    }
  }
  
  @override
  void searchCategories(String query) {
    _searchQuery.value = query.toLowerCase().trim();
    
    // If query is empty, show all categories
    if (_searchQuery.value.isEmpty) {
      _filteredCategories.value = List.from(_categories);
      return;
    }
    
    // Filter categories based on query
    _filteredCategories.value = _categories.where((category) {
      // Search by name, case-insensitive
      return (category.name ?? '').toLowerCase().contains(_searchQuery.value);
    }).toList();
  }
void gotoProduct({required List<CategoriesModels> categories, required String selectedCategoryId}) {
  Get.toNamed(
    AppRoute.productscreen,
    arguments: {
      "categories": categories,
      "selected": selectedCategoryId,
    },
  );
}


}