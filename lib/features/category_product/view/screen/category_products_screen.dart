import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/features/category/models/category.model.dart';
import 'package:store_go/features/home/views/widgets/product_card.dart';
import 'package:store_go/features/home/views/widgets/search_bar.dart';
import 'package:store_go/features/category_product/controller/category_product_controller.dart';
import 'package:store_go/features/filter/controllers/product_filter_controller.dart';
import 'package:store_go/features/category_product/view/widgets/subcategory_list_view.dart';
import 'package:store_go/features/product/models/product_model.dart';
import 'package:store_go/features/search/no_search_result.dart';
import 'package:store_go/features/subcategory/controllers/subcategory_controller.dart';
import 'package:store_go/features/subcategory/repositories/subcategory_repository.dart';

class CategoryProductsScreen extends StatefulWidget {
  final Category category;
  CategoryProductsScreen({super.key}) : category = Get.arguments as Category;

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  final CategoryController categoryController = Get.find<CategoryController>();
  late CategoryProductController categoryProductController;
  late SubcategoryController subcategoryController;

  @override
  void initState() {
    super.initState();

    // Make sure controllers are properly initialized
    if (Get.isRegistered<CategoryProductController>()) {
      categoryProductController = Get.find<CategoryProductController>();
      // Reset the controller state without clearing lists (to prevent flicker)
      categoryProductController.isLoading.value = false;
      categoryProductController.hasError.value = false;
      categoryProductController.errorMessage.value = '';
      categoryProductController.isSearchActive.value = false;
      categoryProductController.searchQuery.value = '';
    } else {
      categoryProductController = Get.put(
        CategoryProductController(repository: Get.find()),
      );
    }

    if (Get.isRegistered<SubcategoryController>()) {
      subcategoryController = Get.find<SubcategoryController>();
    } else {
      subcategoryController = Get.put(
        SubcategoryController(
          repository: SubcategoryRepository(apiClient: Get.find()),
        ),
      );
    }

    // Trigger data loading immediately, don't wait for the first frame
    _initDataLoading();
  }

  void _initDataLoading() async {
    // Set the category for the controllers
    categoryProductController.setCategory(widget.category);
    categoryController.selectedCategoryId.value = widget.category.id;

    // Start both fetches in parallel
    final productsLoadingFuture = categoryProductController
        .fetchCategoryProducts(widget.category.id);

    // Set category for subcategory controller - but don't clear existing subcategories if
    // they're already for this category (prevents flicker)
    if (subcategoryController.currentCategoryId.value != widget.category.id) {
      subcategoryController.setCategory(widget.category.id);
    }

    // Optionally fetch categories if needed
    if (categoryController.categories.isEmpty) {
      categoryController.fetchCategories();
    }

    // Wait for products to load (important for user experience)
    await productsLoadingFuture;
  }

  void applyFilters() {
    final filterController = Get.find<ProductFilterController>();
    categoryProductController.applyFilters(
      categoryId:
          filterController.selectedCategory.value == 'All'
              ? widget.category.id
              : filterController.selectedCategory.value,
      subcategoryId: filterController.selectedSubcategoryId.value,
      minPrice: filterController.minPrice.value,
      maxPrice: filterController.maxPrice.value,
      sortOption: filterController.selectedSortOption.value,
      minRating: filterController.minRating.value.toDouble(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF4F4F4),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                        size: 18,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () => Get.back(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomSearchBar(
                      onSearch: (query) {
                        if (query.isEmpty) {
                          // Clear search results
                          if (subcategoryController
                              .currentSubcategoryId
                              .value
                              .isNotEmpty) {
                            subcategoryController.clearSearch();
                          } else {
                            categoryProductController.clearSearch();
                          }
                          return;
                        }

                        if (subcategoryController
                            .currentSubcategoryId
                            .value
                            .isNotEmpty) {
                          // Search only in selected subcategory
                          subcategoryController.searchSubcategoryProducts(
                            query,
                          );
                        } else {
                          // Search in current category
                          categoryProductController.searchCategoryProducts(
                            query,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Always render the SubcategoryListView
            SubcategoryListView(onApplyFilters: applyFilters),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
              child: Obx(() {
                // Use the filteredProducts list instead of categoryProducts
                final productCount =
                    subcategoryController.currentSubcategoryId.value.isNotEmpty
                        ? subcategoryController.subcategoryProducts.length
                        : categoryProductController.filteredProducts.length;
                final displayName =
                    subcategoryController.currentSubcategoryId.value.isNotEmpty
                        ? subcategoryController.subcategories
                                .firstWhereOrNull(
                                  (sub) =>
                                      sub.id ==
                                      subcategoryController
                                          .currentSubcategoryId
                                          .value,
                                )
                                ?.name ??
                            widget.category.name
                        : widget.category.name;
                return Text(
                  '$productCount Results Found in $displayName',
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }),
            ),
            // Main product grid
            Expanded(
              child: Obx(() {
                // Use isLoadingProducts for subcategory controller to avoid UI flicker
                final isLoading =
                    subcategoryController.currentSubcategoryId.value.isNotEmpty
                        ? subcategoryController.isLoadingProducts.value
                        : categoryProductController.isLoading.value;
                final hasError =
                    subcategoryController.currentSubcategoryId.value.isNotEmpty
                        ? subcategoryController.hasError.value
                        : categoryProductController.hasError.value;
                final errorMessage =
                    subcategoryController.currentSubcategoryId.value.isNotEmpty
                        ? subcategoryController.errorMessage.value
                        : categoryProductController.errorMessage.value;

                // Choose the correct products list based on current selection
                final List<Product> products =
                    subcategoryController.currentSubcategoryId.value.isNotEmpty
                        ? subcategoryController.subcategoryProducts
                        : categoryProductController.isSearchActive.value
                        ? categoryProductController.filteredProducts
                        : categoryProductController.categoryProducts;

                final isSearchActive =
                    subcategoryController.currentSubcategoryId.value.isNotEmpty
                        ? subcategoryController.isSearchActive.value
                        : categoryProductController.isSearchActive.value;

                if (isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                }
                if (hasError) {
                  return Center(
                    child: Text(
                      'Error: $errorMessage',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (products.isEmpty) {
                  return NoSearchResult(
                    onExploreCategories: () {
                      if (isSearchActive) {
                        if (subcategoryController
                            .currentSubcategoryId
                            .value
                            .isNotEmpty) {
                          subcategoryController.clearSearch();
                        } else {
                          categoryProductController.clearSearch();
                        }
                      } else {
                        subcategoryController.resetState();
                        // Make sure to fetch products for the selected category
                        categoryProductController.fetchCategoryProducts(
                          widget.category.id,
                        );
                      }
                    },
                  );
                }

                // Render the products grid
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 159 / 280,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductCard(
                        product: product,
                        onProductTap:
                            (id) => categoryProductController.onProductTap(id),
                        onFavoriteTap:
                            (id) =>
                                categoryProductController.toggleFavorite(id),
                        width: 159,
                        height: 280,
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
