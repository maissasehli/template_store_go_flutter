import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:store_go/features/category/models/category.modal.dart';
import 'package:store_go/features/category/repositories/category_repository.dart';

class CategoryController extends GetxController {
  final CategoryRepository _repository;
  final Logger _logger = Logger();

  // Observable state
  final RxList<Category> categories = <Category>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString selectedCategoryId = ''.obs; // Add this line

  // For search functionality
  final RxList<Category> filteredCategories = <Category>[].obs;

  CategoryController({required CategoryRepository repository})
    : _repository = repository;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    filteredCategories.assignAll(categories);
  }

    Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final items = await _repository.getCategories();
      categories.value = items;
      filteredCategories.value = items;

      // If categories were loaded and we don't have a selected category yet,
      // select the first one by default
      if (categories.isNotEmpty && selectedCategoryId.isEmpty) {
        selectedCategoryId.value = categories.first.id;
      }

      _logger.d("Categories fetched: ${categories.length}");
    } catch (e) {
      _logger.e("Error fetching categories: $e");
      hasError.value = true;
      errorMessage.value = 'Failed to load categories. Please try again later.';
    } finally {
      isLoading.value = false;
    }
  }
  void filterCategories(String query) {
    if (query.isEmpty) {
      // If query is empty, show all categories
      filteredCategories.assignAll(categories);
      return;
    }

    // Filter categories by name containing the query (case insensitive)
    final List<Category> results =
        categories.where((category) {
          return category.name.toLowerCase().contains(query.toLowerCase());
        }).toList();

    // Update the filteredCategories list
    filteredCategories.assignAll(results);
  }

  // Select a category and navigate to the category products screen
 void selectCategory(Category category) {
    _logger.d("Category selected: ${category.id}");

    // Set the selected category ID
    selectedCategoryId.value = category.id;

    // Navigate to the category products screen with the category as an argument
    Get.toNamed(AppRoute.categoryDetail, arguments: category);
  }


  void selectCategoryById(String categoryId) {
    // Find the category with the given ID
    final Category? category = categories.firstWhereOrNull(
      (c) => c.id == categoryId,
    );

    // Only proceed if we found a valid category
    if (category != null) {
      // Update the selected category ID
      selectedCategoryId.value = categoryId;

      // Call the existing selectCategory method with the Category object
      selectCategory(category);
    }
  }
}
