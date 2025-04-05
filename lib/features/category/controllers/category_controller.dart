import 'package:get/get.dart';
import 'package:store_go/features/category/services/category_service.dart';
import 'package:store_go/features/home/models/category_model.dart';
import 'package:logger/logger.dart';

class CategoryController extends GetxController {
  final CategoryService _categoryService;
  final Logger _logger = Logger();

  // Observable variables
  final RxList<Category> categories = <Category>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<String?> errorMessage = Rx<String?>(null);
  // Add the missing selectedCategoryId property
  final RxString selectedCategoryId = ''.obs;

  // Dependency injection through constructor
  CategoryController(this._categoryService);

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  // Fetch all categories
  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      // Get categories from service
      categories.value = await _categoryService.getCategories();

      // If categories were loaded and we don't have a selected category yet,
      // select the first one by default
      if (categories.isNotEmpty && selectedCategoryId.isEmpty) {
        selectedCategoryId.value = categories.first.id;
      }

      _logger.d("Categories fetched: ${categories.length}");
    } catch (e) {
      _logger.e("Error fetching categories: $e");
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
}
