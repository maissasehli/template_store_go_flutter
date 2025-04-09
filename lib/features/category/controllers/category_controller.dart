import 'package:get/get.dart';
import 'package:logger/logger.dart';
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

  // For selected category tracking
  final RxString selectedCategoryId = ''.obs;

  // For search functionality
  final RxList<Category> filteredCategories = <Category>[].obs;

  CategoryController({required CategoryRepository repository})
    : _repository = repository;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
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

  // Select a category and navigate to its products
  void selectCategory(String id) {
    _logger.d("Category selected: $id");
    // Update the selected category ID
    selectedCategoryId.value = id;
    // Navigate to products screen with category ID
    Get.toNamed('/products', arguments: {'categoryId': id});
  }

  void filterCategories(String searchText) {
    if (searchText.isEmpty) {
      filteredCategories.value = categories;
    } else {
      filteredCategories.value =
          categories.where((category) {
            return category.name.toLowerCase().contains(
              searchText.toLowerCase(),
            );
          }).toList();
    }
  }

  bool isCategorySelected(String categoryId) {
    return selectedCategoryId.value == categoryId;
  }
}
