import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/product/models/product_model.dart';
import 'package:store_go/features/subcategory/models/subcategory_model.dart';
import 'package:store_go/features/subcategory/repositories/subcategory_repository.dart';

class SubcategoryController extends GetxController {
  final SubcategoryRepository _repository;
  final Logger _logger = Logger();

  // Observable states
  final RxList<Subcategory> subcategories = <Subcategory>[].obs;
  final RxList<Product> subcategoryProducts = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString currentCategoryId = ''.obs;
  final RxString currentSubcategoryId = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isSearchActive = false.obs;

  // Add this flag to handle visibility during subcategory selection
  final RxBool isLoadingProducts = false.obs;

  SubcategoryController({required SubcategoryRepository repository})
    : _repository = repository;

  void setCategory(String categoryId) {
    // First set the category ID and reset other state
    currentCategoryId.value = categoryId;
    currentSubcategoryId.value = '';
    subcategoryProducts.clear();
    searchQuery.value = '';
    isSearchActive.value = false;

    // Only set loading to true if subcategories are empty
    if (subcategories.isEmpty) {
      isLoading.value = true;
    }

    // Fetch subcategories in the background without blocking the UI
    fetchSubcategories(categoryId)
        .then((_) {
          // Update loading status when done
          isLoading.value = false;
        })
        .catchError((error) {
          // Handle errors gracefully
          _logger.e('Error in setCategory: $error');
          isLoading.value = false;
        });
  }

  Future<void> fetchSubcategories(String categoryId) async {
    try {
      // Don't set isLoading here since we already did it in setCategory
      hasError.value = false;
      errorMessage.value = '';

      final fetchedSubcategories = await _repository
          .getSubcategoriesByCategoryId(categoryId);
      _logger.d(
        "Fetched ${fetchedSubcategories.length} subcategories for category $categoryId",
      );

      // Verify that all subcategories have the correct parentCategoryId
      final validSubcategories =
          fetchedSubcategories
              .where((sub) => sub.parentCategoryId == categoryId)
              .toList();

      if (validSubcategories.length != fetchedSubcategories.length) {
        _logger.w("Some subcategories had incorrect parentCategoryId values");
      }

      // Only update if the category hasn't changed during the fetch
      if (currentCategoryId.value == categoryId) {
        subcategories.assignAll(validSubcategories);
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      _logger.e('Error fetching subcategories for category $categoryId: $e');

      // Only clear if the category hasn't changed
      if (currentCategoryId.value == categoryId) {
        subcategories.clear();
      }
    }
  }

  Future<void> selectSubcategory(Subcategory subcategory) async {
    try {
      // Use our specific product loading flag, not the general isLoading flag
      isLoadingProducts.value = true;
      hasError.value = false;
      errorMessage.value = '';

      // Set the subcategory ID regardless of previous selection
      currentSubcategoryId.value = subcategory.id;
      searchQuery.value = '';
      isSearchActive.value = false;

      final products = await _repository.getProductsBySubcategoryId(
        subcategory.id,
      );
      _logger.d(
        "Fetched ${products.length} products for subcategory ${subcategory.name}",
      );

      subcategoryProducts.assignAll(products);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      _logger.e(
        'Error fetching products for subcategory ${subcategory.name}: $e',
      );
      subcategoryProducts.clear();
    } finally {
      isLoadingProducts.value = false;
    }
  }

  Future<void> searchSubcategoryProducts(String query) async {
    searchQuery.value = query;

    if (query.isEmpty) {
      isSearchActive.value = false;
      if (currentSubcategoryId.value.isNotEmpty) {
        // Reload the original product list
        final subcategory = subcategories.firstWhereOrNull(
          (s) => s.id == currentSubcategoryId.value,
        );
        if (subcategory != null) {
          await selectSubcategory(subcategory);
        }
      }
      return;
    }

    try {
      // Use our specific product loading flag, not the general isLoading flag
      isLoadingProducts.value = true;
      hasError.value = false;
      errorMessage.value = '';
      isSearchActive.value = true;

      List<Product> productsToSearch = [];

      if (currentSubcategoryId.value.isEmpty) {
        // If no subcategory is selected, fetch products from all subcategories
        for (var subcategory in subcategories) {
          final subProducts = await _repository.getProductsBySubcategoryId(
            subcategory.id,
          );
          productsToSearch.addAll(subProducts);
        }
      } else {
        // If a subcategory is selected, only search within that subcategory
        if (subcategoryProducts.isEmpty) {
          productsToSearch = await _repository.getProductsBySubcategoryId(
            currentSubcategoryId.value,
          );
        } else {
          productsToSearch = List.from(subcategoryProducts);
        }
      }

      final filteredProductsList =
          productsToSearch.where((product) {
            return product.name.toLowerCase().contains(query.toLowerCase()) ||
                product.description.toLowerCase().contains(query.toLowerCase());
          }).toList();

      _logger.d(
        "Found ${filteredProductsList.length} products matching '$query' in category $currentCategoryId",
      );
      subcategoryProducts.assignAll(filteredProductsList);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      _logger.e('Error searching products: $e');
    } finally {
      isLoadingProducts.value = false;
    }
  }

  void clearSearch() {
    if (isSearchActive.value && currentSubcategoryId.value.isNotEmpty) {
      searchQuery.value = '';
      isSearchActive.value = false;
      final subcategory = subcategories.firstWhereOrNull(
        (s) => s.id == currentSubcategoryId.value,
      );
      if (subcategory != null) {
        selectSubcategory(subcategory);
      }
    }
  }

  // Modified to maintain subcategory list
  void resetState() {
    currentSubcategoryId.value = '';
    subcategoryProducts.clear();
    searchQuery.value = '';
    isSearchActive.value = false;
    // Note that we're NOT clearing the subcategories list here
  }

  @override
  void onClose() {
    _logger.d("SubcategoryController closed");
    super.onClose();
  }
}
