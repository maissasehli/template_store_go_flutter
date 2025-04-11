import 'package:get/get.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/category/models/categories_model.dart';
import 'package:store_go/features/product/models/product_model.dart';
import 'package:store_go/features/home/services/home_api_service.dart';

class HomeController extends GetxController {
  // Observable loading state
  final isLoading = true.obs;

  // Observable list of products
  final products = <ProductModels>[].obs;

  // Observable list of categories
  final categories = <CategoriesModels>[].obs;

  // Observable for the currently selected category ID
  final selectedCategoryId = ''.obs;

  @override
  void onInit() {
    fetchInitialData();
    super.onInit();
  }

  /// Fetches initial data including products and categories from the API
  Future<void> fetchInitialData() async {
    try {
      isLoading(true);
      final homeApiService = HomeApiService(ApiClient());
      final response = await homeApiService.getHomeData();
      final data = response.data;

      // Load product list from 'items' in the response
      if (data['items'] != null && data['items'] is List) {
        products.assignAll(
          (data['items'] as List)
              .map((product) => ProductModels.fromJson(product))
              .toList(),
        );
      } else {
        products.clear();
      }

      // Load category list from 'categories' in the response
      if (data['categories'] != null && data['categories'] is List) {
        categories.assignAll(
          (data['categories'] as List)
              .map((category) => CategoriesModels.fromJson(category))
              .toList(),
        );
      } else {
        categories.clear();
      }

      // Set the first category as the selected one by default
      if (categories.isNotEmpty) {
        selectedCategoryId.value = categories.first.id ?? '';
      }
    } finally {
      isLoading(false);
    }
  }

  /// Navigates to the product screen with selected category and categories list as arguments
  void gotoProducts(
    List<CategoriesModels> categories,
    CategoriesModels selectedCat,
  ) {
    Get.toNamed(
      AppRoute.productscreen,
      arguments: {"categories": categories, "selected": selectedCat},
    );
  }

  /// Updates the currently selected category ID
  void selectCategory(String categoryId) {
    selectedCategoryId.value = categoryId;
  }

  /// Searches for products based on a query (to be implemented)
  void searchProducts(String query) {
    // TODO: Implement product search logic
  }

  /// Returns a list of top-selling products
  /// Currently returns all products — can be updated for more advanced logic
  List<ProductModels> getTopSellingProducts() {
    final List<ProductModels> result = [];
    final int count = products.length;

    for (int i = 0; i < count; i++) {
      result.add(products[i]);
    }

    return result;
  }

  /// Toggles the favorite status of a product by its ID


  void navigateToProductDetail(String productId) {
    Get.toNamed(AppRoute.productdetail, arguments: {'productId': productId});
  }
}
