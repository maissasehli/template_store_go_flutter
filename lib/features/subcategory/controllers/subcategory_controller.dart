import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/product/models/product_model.dart';
import 'package:store_go/features/subcategory/models/subcategory_model.dart';
import 'package:store_go/features/subcategory/repositories/subcategory_repository.dart';

class SubcategoryController extends GetxController {
  final SubcategoryRepository _repository;
  final Logger _logger = Logger();

  final RxList<Subcategory> subcategories = <Subcategory>[].obs;
  final RxList<Product> subcategoryProducts = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  final RxString currentCategoryId = ''.obs;
  final RxString currentSubcategoryId = ''.obs;

  final RxString searchQuery = ''.obs;
  final RxBool isSearchActive = false.obs;

  SubcategoryController({required SubcategoryRepository repository}) : _repository = repository;

  void setCategory(String categoryId) {
    currentCategoryId.value = categoryId;
    currentSubcategoryId.value = '';
    subcategories.clear();
    subcategoryProducts.clear();
    searchQuery.value = '';
    isSearchActive.value = false;
    hasError.value = false;
    errorMessage.value = '';

    fetchSubcategories(categoryId);
  }

  // New method to reset state when refreshing or clearing filters
  void resetState() {
    currentCategoryId.value = '';
    currentSubcategoryId.value = '';
    subcategories.clear();
    subcategoryProducts.clear();
    searchQuery.value = '';
    isSearchActive.value = false;
    hasError.value = false;
    errorMessage.value = '';
  }

  Future<void> fetchSubcategories(String categoryId) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final items = await _repository.getSubcategoriesByCategoryId(categoryId);
      subcategories.assignAll(items);

      _logger.d("Subcategories fetched: ${subcategories.length} for category $categoryId");
    } catch (e) {
      _logger.e("Error fetching subcategories for category $categoryId: $e");
      hasError.value = true;
      errorMessage.value = 'Failed to load subcategories: $e';
      subcategories.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void selectSubcategory(Subcategory subcategory) {
    currentSubcategoryId.value = subcategory.id;
    fetchSubcategoryProducts(subcategory.id);
  }

  Future<void> fetchSubcategoryProducts(String subcategoryId) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final products = await _repository.getProductsBySubcategoryId(subcategoryId);
      subcategoryProducts.assignAll(products);

      _logger.d("Fetched ${products.length} products for subcategory $subcategoryId");
    } catch (e) {
      _logger.e("Error fetching products for subcategory $subcategoryId: $e");
      hasError.value = true;
      errorMessage.value = 'Failed to load products: $e';
      subcategoryProducts.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchSubcategoryProducts(String query) async {
    searchQuery.value = query;

    if (query.isEmpty) {
      isSearchActive.value = false;
      if (currentSubcategoryId.value.isNotEmpty) {
        fetchSubcategoryProducts(currentSubcategoryId.value);
      }
      return;
    }

    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      isSearchActive.value = true;

      List<Product> allSubcategoryProducts;
      if (subcategoryProducts.isEmpty && currentSubcategoryId.value.isNotEmpty) {
        allSubcategoryProducts = await _repository.getProductsBySubcategoryId(currentSubcategoryId.value);
      } else {
        allSubcategoryProducts = List.from(subcategoryProducts);
      }

      final filteredProducts = allSubcategoryProducts.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase()) ||
            product.description.toLowerCase().contains(query.toLowerCase());
      }).toList();

      _logger.d("Found ${filteredProducts.length} products matching '$query' in subcategory ${currentSubcategoryId.value}");
      subcategoryProducts.assignAll(filteredProducts);
    } catch (e) {
      _logger.e("Error searching products in subcategory: $e");
      hasError.value = true;
      errorMessage.value = 'Error searching products: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void clearSearch() {
    if (isSearchActive.value && currentSubcategoryId.value.isNotEmpty) {
      searchQuery.value = '';
      isSearchActive.value = false;
      fetchSubcategoryProducts(currentSubcategoryId.value);
    }
  }

  @override
  void onClose() {
    _logger.d("SubcategoryController closed");
    super.onClose();
  }
}