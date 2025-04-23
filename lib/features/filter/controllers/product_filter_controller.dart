import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/product/controllers/product_controller.dart';
import 'dart:developer' as developer;

class ProductFilterController extends GetxController {
  final ProductController productController;
  final Logger _logger = Logger();

  // Filter state
  final RxString selectedCategory = 'All'.obs;
  final RxString selectedSubcategoryId = ''.obs;
  final RxString selectedSortOption = 'Latest'.obs;
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 1000.0.obs;
  final RxInt minRating = 0.obs;

  ProductFilterController({required this.productController});

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args['subcategoryId'] != null) {
      selectedSubcategoryId.value = args['subcategoryId'];
    }
  }

  Future<void> applyFilters() async {
    try {
      await productController.filterProducts(
        category: selectedCategory.value == 'All' ? null : selectedCategory.value,
        subcategory: selectedSubcategoryId.value.isEmpty ? null : selectedSubcategoryId.value,
        minPrice: minPrice.value,
        maxPrice: maxPrice.value,
        sortBy: selectedSortOption.value,
        rating: minRating.value,
      );

      developer.log(
          'Applied filters: category=${selectedCategory.value}, '
          'subcategory=${selectedSubcategoryId.value}, '
          'price=${minPrice.value}-${maxPrice.value}, '
          'sort=${selectedSortOption.value}, '
          'rating=${minRating.value}',
          name: 'ProductFilterController.applyFilters');
          
      return;
    } catch (e) {
      _logger.e('Error applying filters: $e');
      developer.log('Error applying filters: $e',
          name: 'ProductFilterController.applyFilters', error: e);
      throw e;
    }
  }

  Future<void> clearFilters() async {
    selectedCategory.value = 'All';
    selectedSubcategoryId.value = '';
    selectedSortOption.value = 'Latest';
    minPrice.value = 0.0;
    maxPrice.value = 1000.0;
    minRating.value = 0;

    await productController.clearFilters();
    developer.log('Cleared all filters', name: 'ProductFilterController.clearFilters');
  }

  List<String> get sortOptions => [
        'Latest',
        'New Today',
        'Top Sellers',
        'New collection',
      ];
}