import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/features/category/models/category.modal.dart';
import 'package:store_go/features/home/controllers/home_controller.dart';
import 'package:store_go/features/home/views/widgets/product_card.dart';
import 'package:store_go/features/home/views/widgets/search_bar.dart';
import 'package:store_go/features/product/controllers/category_product_controller.dart';
import 'package:store_go/features/product/views/widgets/category_product/category_list_view.dart';
import 'package:store_go/features/profile/controllers/profile_controller.dart';
import 'package:store_go/features/search/no_search_result.dart';

class CategoryProductsScreen extends StatefulWidget {
  final Category category;

  CategoryProductsScreen({super.key})
    : category = Get.arguments as Category;

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  final HomeController homeController = Get.find<HomeController>();
  final CategoryController categoryController = Get.find<CategoryController>();
  late CategoryProductController categoryProductController;
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();

    // Find or create the category product controller
    if (Get.isRegistered<CategoryProductController>()) {
      categoryProductController = Get.find<CategoryProductController>();
    } else {
      // Create and register the controller if not already registered
      categoryProductController = Get.put(
        CategoryProductController(
          repository: Get.find(), // Should automatically find your ProductRepository
        ),
      );
    }

    // Schedule the data fetching for after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initCategoryProducts();
    });
  }

  void _initCategoryProducts() {
    // Set the current category and fetch its products
    categoryProductController.setCategory(widget.category);

    // Set the selected category in the category controller
    categoryController.selectedCategoryId.value = widget.category.id;

    // Ensure we have all categories loaded for the filter
    if (categoryController.categories.isEmpty) {
      categoryController.fetchCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom header with back button and search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  // Circular back button
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

                  // Expanded custom search bar
                  Expanded(
                    child: CustomSearchBar(
                      onSearch: (query) => 
                          categoryProductController.searchCategoryProducts(query),
                    ),
                  ),
                ],
              ),
            ),

            // Category filter horizontal list using the extracted widget
            CategoryListView(categoryProductController: categoryProductController),

            // Results count text
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
              child: Obx(
                () => Text(
                  '${categoryProductController.categoryProducts.length} Results Found',
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // Products grid
            Expanded(
              child: Obx(() {
                if (categoryProductController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                }

                if (categoryProductController.hasError.value) {
                  return Center(
                    child: Text(
                      'Error: ${categoryProductController.errorMessage.value}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (categoryProductController.categoryProducts.isEmpty) {
                  return NoSearchResult(
                    onExploreCategories: () {
                      // If we're searching, clear the search to show all category products
                      if (categoryProductController.isSearchActive.value) {
                        categoryProductController.clearSearch();
                      } else {
                        // Otherwise, reload products for this category
                        categoryProductController.fetchCategoryProducts(
                          widget.category.id,
                        );
                      }
                    },
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: categoryProductController.categoryProducts.length,
                    itemBuilder: (context, index) {
                      final product = categoryProductController.categoryProducts[index];

                      return ProductCard(
                        product: product,
                        onProductTap: (id) => homeController.onProductTap(id),
                        onFavoriteTap: (id) => categoryProductController.toggleFavorite(id),
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