import 'package:get/get.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:store_go/features/category/models/categories_model.dart';
import 'package:store_go/features/product/models/product_model.dart';
import 'package:store_go/features/product/services/product_api_service.dart';
import 'package:store_go/app/core/services/api_client.dart';

abstract class productController extends GetxController {
  initialData();
  filterByCategory(String categoryId);
  resetFilter();
  toggleFavorite(String productId);
}

class ProductControllerImp  extends productController {
  final isLoading = true.obs;
  final products = <ProductModels>[].obs;
  final filteredProducts = <ProductModels>[].obs;
  final categories = <CategoriesModels>[].obs;
  final selectedCat = Rx<String?>(null);

  final ProductApiService _productApiService = ProductApiService(ApiClient());
  final searchQuery = ''.obs;

  @override
  void onInit() {
    initialData();
    super.onInit();
  }

  @override
  initialData() async {
    try {
      isLoading(true);

      // Check if arguments are passed (e.g., from previous screen)
      if (Get.arguments != null && Get.arguments is Map) {
        final args = Get.arguments as Map;

        // Load categories from arguments if available
        if (args['categories'] != null && args['categories'] is List) {
          final categoriesList = args['categories'] as List;
          categories.assignAll(
            categoriesList.map((cat) =>
              cat is CategoriesModels ? cat : CategoriesModels.fromJson(cat)
            ).toList()
          );
        } else {
          // Fetch categories from the API if not found in arguments
          await fetchCategories();
        }

        // Check for selected category and fetch related products
        if (args['selected'] != null) {
          selectedCat.value = args['selected'].toString();
          await fetchProductsByCategory(selectedCat.value!);
        } else {
          await fetchAllProducts();
        }
      } else {
        // No valid arguments, fetch everything from the API
        await fetchCategories();
        await fetchAllProducts();
      }
    } catch (e) {
      // If an error occurs, try to fetch everything from the API
      await fetchCategories();
      await fetchAllProducts();
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchCategories() async {
    try {
      final response = await _productApiService.getCategories();
      final data = response.data;

      // Parse response depending on its structure
      if (data is Map && data.containsKey('categories') && data['categories'] is List) {
        categories.assignAll(
          (data['categories'] as List)
              .map((category) => CategoriesModels.fromJson(category))
              .toList(),
        );
      } else if (data is List) {
        categories.assignAll(
          data.map((category) => CategoriesModels.fromJson(category)).toList(),
        );
      }
    } catch (e) {
      // Handle errors if the categories API fails
    }
  }

  Future<void> fetchAllProducts() async {
    try {
final response = await _productApiService.getAllProducts();
      final data = response.data;

      // Support multiple backend response structures
      if (data is Map && data['items'] != null && data['items'] is List) {
        products.assignAll(
          (data['items'] as List)
              .map((product) => ProductModels.fromJson(product))
              .toList(),
        );
        filteredProducts.assignAll(products);
      } else if (data is Map && data['data'] != null && data['data'] is List) {
        products.assignAll(
          (data['data'] as List)
              .map((product) => ProductModels.fromJson(product))
              .toList(),
        );
        filteredProducts.assignAll(products);
      }
    } catch (e) {
      // Handle errors if the products API fails
    }
  }

  Future<void> fetchProductsByCategory(String categoryId) async {
    try {
      isLoading(true);
      final response = await _productApiService.getProductsByCategory(categoryId);
      final data = response.data;

      filteredProducts.clear(); // Clear the existing filtered list

      // Handle various response structures
      if (data is Map) {
        if (data['data'] != null && data['data'] is List) {
          filteredProducts.assignAll(
            (data['data'] as List)
                .map((product) => ProductModels.fromJson(product))
                .toList(),
          );
        } else if (data['items'] != null && data['items'] is List) {
          filteredProducts.assignAll(
            (data['items'] as List)
                .map((product) => ProductModels.fromJson(product))
                .toList(),
          );
        } else if (data['status'] == 'success' && data.containsKey('data') && data['data'] is List) {
          filteredProducts.assignAll(
            (data['data'] as List)
                .map((product) => ProductModels.fromJson(product))
                .toList(),
          );
        }
      } else if (data is List) {
        // In case the response is a direct list
        filteredProducts.assignAll(
          data.map((product) => ProductModels.fromJson(product)).toList()
        );
      }
    } catch (e) {
      // Handle errors if fetching by category fails
    } finally {
      isLoading(false);
    }
  }

  @override
  filterByCategory(String categoryId) {
    selectedCat.value = categoryId;

    if (categoryId.isEmpty) {
      filteredProducts.assignAll(products);
      return;
    }

    // Always fetch from API to ensure updated data
    fetchProductsByCategory(categoryId);
  }

  @override
  resetFilter() {
    selectedCat.value = null;
    filteredProducts.assignAll(products);
  }

  changeCat(dynamic val) {
    // Convert selected category to string
    if (val is String) {
      selectedCat.value = val;
    } else if (val != null) {
      selectedCat.value = val.toString();
    } else {
      selectedCat.value = null;
    }

    // Refresh product list after changing category
    if (selectedCat.value != null) {
      filterByCategory(selectedCat.value!);
    } else {
      resetFilter();
    }
  }

  @override
  toggleFavorite(String productId) {
    // Toggle favorite status in the full product list
    final productIndex = products.indexWhere((product) => product.id == productId);
    if (productIndex != -1) {
      final product = products[productIndex];
      final isFavorite = !(product.isFavorite ?? false);
      products[productIndex] = product.copyWith(isFavorite: isFavorite);
    }

    // Toggle favorite status in the filtered product list
    final filteredIndex = filteredProducts.indexWhere((product) => product.id == productId);
    if (filteredIndex != -1) {
      final product = filteredProducts[filteredIndex];
      final isFavorite = !(product.isFavorite ?? false);
      filteredProducts[filteredIndex] = product.copyWith(isFavorite: isFavorite);

      // Notify backend about the change
      _productApiService.toggleFavorite(productId, isFavorite);
    }
  }

  void searchProducts(String query) {
    searchQuery.value = query;

    if (query.isEmpty) {
      // Reset search to full or filtered products
      if (selectedCat.value != null) {
        filterByCategory(selectedCat.value!);
      } else {
        filteredProducts.assignAll(products);
      }
      return;
    }

    // Search based on product name and optional category filter
    final queryLower = query.toLowerCase();
    final List<ProductModels> searchResults;

    if (selectedCat.value != null) {
      searchResults = products.where((product) =>
        product.categoryId == selectedCat.value &&
        (product.name?.toLowerCase().contains(queryLower) ?? false)
      ).toList();
    } else {
      searchResults = products.where((product) =>
        product.name?.toLowerCase().contains(queryLower) ?? false
      ).toList();
    }

    filteredProducts.assignAll(searchResults);
  }
  void navigateToProductDetail(String productId) {
  Get.toNamed(
    AppRoute.productdetail, 
    arguments: {'productId': productId}
  );
}
}
