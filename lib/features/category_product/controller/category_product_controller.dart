import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:store_go/features/category/models/category.model.dart';
import 'package:store_go/features/product/models/product_model.dart';
import 'package:store_go/features/product/repositories/product_repository.dart';
import 'package:store_go/features/review/controllers/review_controller.dart';

class CategoryProductController extends GetxController {
  final ProductRepository _repository;
  final Logger _logger = Logger();

  // Observable states
  final RxList<Product> categoryProducts = <Product>[].obs;
  final RxList<Product> filteredProducts = <Product>[].obs;

  // Cache of original products for the current category
  final RxList<Product> _originalCategoryProducts = <Product>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<Category?> currentCategory = Rx<Category?>(null);
  final RxString searchQuery = ''.obs;
  final RxBool isSearchActive = false.obs;

  CategoryProductController({required ProductRepository repository})
    : _repository = repository;

  void setCategory(Category category) {
    currentCategory.value = category;
    searchQuery.value = '';
    isSearchActive.value = false;
    categoryProducts.clear();
    filteredProducts.clear();
    _originalCategoryProducts.clear();
    _logger.d("Category set: ${category.name} (ID: ${category.id})");
  }

  Future<void> fetchCategoryProducts(String categoryId) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      _logger.d("Fetching products for category ID: $categoryId");

      // Ensure we're requesting products for the specific category ID
      final products = await _repository.getProductsByCategory(categoryId);

      _logger.d(
        "Fetched ${products.length} products for category ID: $categoryId",
      );

      // Clear any existing products and assign the new ones
      categoryProducts.clear();
      filteredProducts.clear();

      // Store the original unfiltered products list
      _originalCategoryProducts.assignAll(products);

      // Assign products to both lists to ensure they match
      categoryProducts.assignAll(products);
      filteredProducts.assignAll(products);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      _logger.e('Error fetching products for category $categoryId: $e');
      categoryProducts.clear();
      filteredProducts.clear();
      _originalCategoryProducts.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // Add this method to restore the original product list when returning to "All"
  void restoreAllCategoryProducts() {
    _logger.d(
      "Restoring all category products: ${_originalCategoryProducts.length}",
    );
    if (_originalCategoryProducts.isNotEmpty) {
      categoryProducts.assignAll(_originalCategoryProducts);
      filteredProducts.assignAll(_originalCategoryProducts);
      isSearchActive.value = false;
      searchQuery.value = '';
    } else if (currentCategory.value != null) {
      // If for some reason original products are empty, re-fetch them
      fetchCategoryProducts(currentCategory.value!.id);
    }
  }

  Future<void> searchCategoryProducts(String query) async {
    searchQuery.value = query;

    if (query.isEmpty) {
      isSearchActive.value = false;
      if (currentCategory.value != null) {
        // Use original products to restore the list
        filteredProducts.assignAll(
          _originalCategoryProducts.isNotEmpty
              ? _originalCategoryProducts
              : categoryProducts,
        );
      }
      return;
    }

    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      isSearchActive.value = true;

      // Use the cached original products list for searching
      final allCategoryProducts =
          _originalCategoryProducts.isNotEmpty
              ? List<Product>.from(_originalCategoryProducts)
              : categoryProducts.isNotEmpty
              ? List<Product>.from(categoryProducts)
              : (currentCategory.value != null
                  ? await _repository.getProductsByCategory(
                    currentCategory.value!.id,
                  )
                  : <Product>[]);

      final filteredProductsList =
          allCategoryProducts.where((product) {
            return product.name.toLowerCase().contains(query.toLowerCase()) ||
                product.description.toLowerCase().contains(query.toLowerCase());
          }).toList();

      _logger.d(
        "Found ${filteredProductsList.length} products matching '$query' in category ${currentCategory.value?.id}",
      );
      filteredProducts.assignAll(filteredProductsList);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      _logger.e('Error searching products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> applyFilters({
    required String categoryId,
    required String subcategoryId,
    required double minPrice,
    required double maxPrice,
    required String sortOption,
    required double minRating,
  }) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      _logger.d(
        "🔍 Applying filters - Category: $categoryId, Subcategory: $subcategoryId",
      );

      List<Product> products;

      // If returning to "All" (no subcategory) and we have the original products,
      // use them as a starting point to avoid fetching again
      if (subcategoryId.isEmpty && _originalCategoryProducts.isNotEmpty) {
        products = List<Product>.from(_originalCategoryProducts);
        _logger.d("Using cached products for 'All' filter: ${products.length}");
      } else {
        try {
          products = await _repository.getFilteredProducts(
            categoryId: categoryId.isNotEmpty ? categoryId : null,
            subcategoryId: subcategoryId.isNotEmpty ? subcategoryId : null,
            minPrice: minPrice,
            maxPrice: maxPrice,
            minRating: minRating > 0 ? minRating : null,
            sortOption: sortOption,
          );
        } catch (e) {
          _logger.w(
            'Server-side filtering failed, falling back to client-side: $e',
          );

          if (subcategoryId.isNotEmpty) {
            products = await _repository.getProductsBySubcategory(
              subcategoryId,
            );
          } else if (_originalCategoryProducts.isNotEmpty) {
            // If we're filtering "All" products, use cached originals
            products = List<Product>.from(_originalCategoryProducts);
          } else {
            products = await _repository.getProductsByCategory(
              categoryId.isNotEmpty ? categoryId : currentCategory.value!.id,
            );
            // Cache these if they're the originals
            if (subcategoryId.isEmpty && _originalCategoryProducts.isEmpty) {
              _originalCategoryProducts.assignAll(products);
            }
          }

          // Apply price filter
          products =
              products.where((product) {
                return product.price >= minPrice && product.price <= maxPrice;
              }).toList();

          // Apply rating filter
          if (minRating > 0) {
            final reviewController = Get.find<ReviewController>();
            products = await Future.wait(
              products.map((product) async {
                if (product.rating >= minRating) {
                  return product;
                }
                final reviews = await reviewController.getReviewsByProductId(
                  product.id,
                );
                final avgRating =
                    reviews.isNotEmpty
                        ? reviews.fold<double>(0, (sum, r) => sum + r.rating) /
                            reviews.length
                        : 0.0;
                return avgRating >= minRating ? product : null;
              }),
            ).then((results) => results.whereType<Product>().toList());
          }

          // Apply sorting
          switch (sortOption) {
            case 'New Today':
              products.sort((a, b) => b.createdAt.compareTo(a.createdAt));
              break;
            case 'Top Sellers':
              products.sort(
                (a, b) => (b.salesCount ?? 0).compareTo(a.salesCount ?? 0),
              );
              break;
            case 'Price: Low to High':
              products.sort((a, b) => a.price.compareTo(b.price));
              break;
            case 'Price: High to Low':
              products.sort((a, b) => b.price.compareTo(a.price));
              break;
          }
        }
      }

      categoryProducts.assignAll(products);
      filteredProducts.assignAll(products);

      _logger.i('Applied filters: ${products.length} products found');
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to apply filters: $e';
      _logger.e('Error applying filters: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFavorite(String productId) async {
    final productIndex = filteredProducts.indexWhere((p) => p.id == productId);
    if (productIndex == -1) return;

    final product = filteredProducts[productIndex];
    final newFavoriteStatus = !product.isFavorite;

    filteredProducts[productIndex] = product.copyWith(
      isFavorite: newFavoriteStatus,
    );

    // Update in category products list
    final categoryIndex = categoryProducts.indexWhere((p) => p.id == productId);
    if (categoryIndex != -1) {
      categoryProducts[categoryIndex] = product.copyWith(
        isFavorite: newFavoriteStatus,
      );
    }

    // Update in original products cache
    final originalIndex = _originalCategoryProducts.indexWhere(
      (p) => p.id == productId,
    );
    if (originalIndex != -1) {
      _originalCategoryProducts[originalIndex] = product.copyWith(
        isFavorite: newFavoriteStatus,
      );
    }

    try {
      final success = await _repository.updateFavoriteStatus(
        productId,
        newFavoriteStatus,
      );
      if (!success) {
        // Revert changes if server update fails
        filteredProducts[productIndex] = product;
        if (categoryIndex != -1) {
          categoryProducts[categoryIndex] = product;
        }
        if (originalIndex != -1) {
          _originalCategoryProducts[originalIndex] = product;
        }
        _logger.e('Server rejected favorite status update');
      }
    } catch (e) {
      // Revert changes on error
      filteredProducts[productIndex] = product;
      if (categoryIndex != -1) {
        categoryProducts[categoryIndex] = product;
      }
      if (originalIndex != -1) {
        _originalCategoryProducts[originalIndex] = product;
      }
      _logger.e('Error updating favorite status: $e');
    }
  }

  void clearSearch() {
    if (isSearchActive.value && currentCategory.value != null) {
      searchQuery.value = '';
      isSearchActive.value = false;
      // Use original products to restore list after search
      filteredProducts.assignAll(
        _originalCategoryProducts.isNotEmpty
            ? _originalCategoryProducts
            : categoryProducts,
      );
    }
  }

  @override
  void onClose() {
    _logger.d("CategoryProductController closed");
    super.onClose();
  }

  void onProductTap(String productId) {
    Get.toNamed(AppRoute.productDetail.replaceAll(':id', productId));
  }
}
