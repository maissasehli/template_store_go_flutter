import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/features/category/models/category.modal.dart';
import 'package:store_go/features/filter/view/screen/filter_screen.dart';
import 'package:store_go/features/home/controllers/home_controller.dart';
import 'package:store_go/features/home/views/widgets/product_card.dart';
import 'package:store_go/features/home/views/widgets/search_bar.dart';
import 'package:store_go/features/product/controllers/category_product_controller.dart';
import 'package:store_go/features/product/views/widgets/category_product/category_list_view.dart';
import 'package:store_go/features/product/views/widgets/category_product/subcategory_list_view.dart';
import 'package:store_go/features/profile/controllers/profile_controller.dart';
import 'package:store_go/features/search/no_search_result.dart';
import 'package:store_go/features/subcategory/controllers/subcategory_controller.dart';
import 'package:store_go/features/subcategory/repositories/subcategory_repository.dart';

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
  late SubcategoryController subcategoryController;
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();

    if (Get.isRegistered<CategoryProductController>()) {
      categoryProductController = Get.find<CategoryProductController>();
    } else {
      categoryProductController = Get.put(
        CategoryProductController(
          repository: Get.find(),
        ),
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initCategoryProducts();
    });
  }

  void _initCategoryProducts() {
    categoryProductController.setCategory(widget.category);
    categoryController.selectedCategoryId.value = widget.category.id;
    subcategoryController.setCategory(widget.category.id);

    if (categoryController.categories.isEmpty) {
      categoryController.fetchCategories();
    }
  }

  void applyFilters() async {
  final result = await showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return FilterPage();
      },
    ),
  );

  if (result != null) {
    final String categoryId = result['categoryId'];
    final String subcategoryId = result['subcategoryId'];
    final double minPrice = result['minPrice'];
    final double maxPrice = result['maxPrice'];

    if (categoryId != widget.category.id) {
      final newCategory = categoryController.categories.firstWhereOrNull((cat) => cat.id == categoryId);
      if (newCategory != null) {
        // Instead of reassigning widget.category, navigate to a new screen or update controllers
        Get.off(() => CategoryProductsScreen(), arguments: newCategory);
        return; // Exit early after navigation
      }
    }

    if (subcategoryId.isNotEmpty) {
      final newSubcategory = subcategoryController.subcategories.firstWhereOrNull((sub) => sub.id == subcategoryId);
      if (newSubcategory != null) {
        subcategoryController.selectSubcategory(newSubcategory);
      }
    } else {
      subcategoryController.currentSubcategoryId.value = '';
      await categoryProductController.fetchCategoryProducts(widget.category.id);
    }

    if (subcategoryController.currentSubcategoryId.value.isNotEmpty) {
      subcategoryController.subcategoryProducts.assignAll(
        subcategoryController.subcategoryProducts.where((product) {
          return product.price >= minPrice && product.price <= maxPrice;
        }).toList(),
      );
    } else {
      categoryProductController.categoryProducts.assignAll(
        categoryProductController.categoryProducts.where((product) {
          return product.price >= minPrice && product.price <= maxPrice;
        }).toList(),
      );
    }
  }
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
                        if (subcategoryController.currentSubcategoryId.value.isNotEmpty) {
                          subcategoryController.searchSubcategoryProducts(query);
                        } else {
                          categoryProductController.searchCategoryProducts(query);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Obx(() {
              if (subcategoryController.currentCategoryId.value == widget.category.id &&
                  subcategoryController.subcategories.isNotEmpty &&
                  !subcategoryController.isLoading.value &&
                  subcategoryController.subcategories.every((sub) => sub.parentCategoryId == widget.category.id)) {
                return SubcategoryListView(applyFilters: applyFilters);
              } else {
                return CategoryListView(
                  categoryProductController: categoryProductController,
                  applyFilters: applyFilters,
                );
              }
            }),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
              child: Obx(() {
                final productCount = subcategoryController.currentSubcategoryId.value.isNotEmpty
                    ? subcategoryController.subcategoryProducts.length
                    : categoryProductController.categoryProducts.length;
                final displayName = subcategoryController.currentSubcategoryId.value.isNotEmpty
                    ? subcategoryController.subcategories
                        .firstWhereOrNull((sub) => sub.id == subcategoryController.currentSubcategoryId.value)
                        ?.name ?? widget.category.name
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
            Expanded(
              child: Obx(() {
                final isLoading = subcategoryController.currentSubcategoryId.value.isNotEmpty
                    ? subcategoryController.isLoading.value
                    : categoryProductController.isLoading.value;
                final hasError = subcategoryController.currentSubcategoryId.value.isNotEmpty
                    ? subcategoryController.hasError.value
                    : categoryProductController.hasError.value;
                final errorMessage = subcategoryController.currentSubcategoryId.value.isNotEmpty
                    ? subcategoryController.errorMessage.value
                    : categoryProductController.errorMessage.value;
                final products = subcategoryController.currentSubcategoryId.value.isNotEmpty
                    ? subcategoryController.subcategoryProducts
                    : categoryProductController.categoryProducts;
                final isSearchActive = subcategoryController.currentSubcategoryId.value.isNotEmpty
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
                        if (subcategoryController.currentSubcategoryId.value.isNotEmpty) {
                          subcategoryController.clearSearch();
                        } else {
                          categoryProductController.clearSearch();
                        }
                      } else {
                        subcategoryController.resetState();
                        categoryProductController.fetchCategoryProducts(widget.category.id);
                        subcategoryController.setCategory(widget.category.id);
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
                      childAspectRatio: 159 / 280,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductCard(
                        product: product,
                        onProductTap: (id) => homeController.onProductTap(id),
                        onFavoriteTap: (id) => categoryProductController.toggleFavorite(id),
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