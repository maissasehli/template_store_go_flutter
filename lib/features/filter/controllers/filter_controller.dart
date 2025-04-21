import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/category/models/category.modal.dart';
import 'package:store_go/features/category/repositories/category_repository.dart';
import 'package:store_go/features/subcategory/models/subcategory_model.dart';
import 'package:store_go/features/subcategory/repositories/subcategory_repository.dart';

class FilterController extends GetxController {
  final SubcategoryRepository _subcategoryRepository;
  final Logger _logger = Logger();

  // State
  final RxList<Category> categories = <Category>[].obs;
  final RxList<Subcategory> subcategories = <Subcategory>[].obs;
  final RxString selectedCategoryId = ''.obs;
  final RxString selectedSubcategoryId = ''.obs;
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 1000.0.obs;
  final RxString selectedSortOption = 'New Today'.obs; // New: Sort option
  final RxInt selectedRating = 0.obs; // New: Rating filter
  final RxBool isLoading = false.obs;

  FilterController({SubcategoryRepository? subcategoryRepository})
      : _subcategoryRepository = subcategoryRepository ??
            SubcategoryRepository(apiClient: Get.find<ApiClient>()) {
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final response = await Get.find<CategoryRepository>().getCategories();
      categories.assignAll(response);
      if (categories.isNotEmpty && selectedCategoryId.value.isEmpty) {
        selectedCategoryId.value = '';
      }
    } catch (e) {
      _logger.e("Error fetching categories for filter: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSubcategories(String categoryId) async {
    try {
      isLoading.value = true;
      final response =
          await _subcategoryRepository.getSubcategoriesByCategoryId(categoryId);
      subcategories.assignAll(response);
      if (subcategories.isNotEmpty && selectedSubcategoryId.value.isEmpty) {
        selectedSubcategoryId.value = '';
      }
    } catch (e) {
      _logger.e("Error fetching subcategories for filter: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    Get.back(result: {
      'categoryId': selectedCategoryId.value,
      'subcategoryId': selectedSubcategoryId.value,
      'minPrice': minPrice.value,
      'maxPrice': maxPrice.value,
      'sortOption': selectedSortOption.value,
      'minRating': selectedRating.value,
    });
  }

  void resetFilters() {
    selectedCategoryId.value = '';
    selectedSubcategoryId.value = '';
    subcategories.clear();
    minPrice.value = 0.0;
    maxPrice.value = 1000.0;
    selectedSortOption.value = 'New Today';
    selectedRating.value = 0;
  }
}