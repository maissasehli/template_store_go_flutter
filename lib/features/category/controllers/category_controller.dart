import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:store_go/features/category/models/category.model.dart';
import 'package:store_go/features/category/repositories/category_repository.dart';

class CategoryController extends GetxController {
  final CategoryRepository _repository;
  final Logger _logger = Logger();
  final RxBool isSearchActive = false.obs;

  final RxList<Category> categories = <Category>[].obs;
  final RxList<Category> filteredCategories = <Category>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString selectedCategoryId = ''.obs;
  final RxString searchQuery = ''.obs;

  CategoryController({required CategoryRepository repository}) : _repository = repository;

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

  Future<void> filterCategories(String query) async {
    try {
      searchQuery.value = query;
      isSearchActive.value = query.isNotEmpty;

      if (query.isEmpty) {
        filteredCategories.assignAll(categories);
        return;
      }

      final List<Category> results = categories
          .where((category) => category.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

      filteredCategories.assignAll(results);

      _logger.d("Filtered categories: ${results.length} results for query '$query'");
    } catch (e) {
      _logger.e("Error filtering categories: $e");
    }
  }

  void clearSearch() {
    _logger.d("Clearing search - categories count: ${categories.length}");
    searchQuery.value = '';
    isSearchActive.value = false;

    if (categories.isNotEmpty) {
      filteredCategories.assignAll(categories);
      _logger.d("Search cleared - filtered categories reset to: ${filteredCategories.length}");
    } else {
      _logger.w("Search cleared but categories list is empty!");
      fetchCategories();
    }
  }

  void selectCategory(Category category) {
    _logger.d("Category selected: ${category.id}");
    selectedCategoryId.value = category.id;

    // Navigate to the category products screen
    Get.toNamed(AppRoute.categoryDetail, arguments: category);
  }

  void selectCategoryById(String categoryId) {
    final Category? category = categories.firstWhereOrNull((c) => c.id == categoryId);

    if (category != null) {
      selectedCategoryId.value = categoryId;
      selectCategory(category);
    }
  }
}