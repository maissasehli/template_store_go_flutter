import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/features/home/controllers/home_controller.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/home/views/widgets/category_filter.dart';
import 'package:store_go/features/home/views/widgets/custom_app_bar.dart';
import 'package:store_go/features/home/views/widgets/product_grid.dart';
import 'package:store_go/features/home/views/widgets/search_bar.dart';
import 'package:store_go/features/home/views/widgets/section_header.dart';
import 'package:store_go/features/profile/controllers/profile_controller.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final CategoryController categoryController = Get.find<CategoryController>();
  final ProfileController profileController = Get.find<ProfileController>();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: CustomAppBar(
        profileController: profileController,
        onSearch: (query) => controller.productController.searchProducts(query),
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // Refresh products data
        await controller.productController.fetchAllProducts();
        await controller.productController.fetchFeaturedProducts();
        await controller.productController.fetchNewProducts();
      },
      color: AppColors.primary(context),
      child: SingleChildScrollView(
        physics:
            const AlwaysScrollableScrollPhysics(), // Important for RefreshIndicator to work
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: UIConfig.paddingMedium),

            // Search bar
            CustomSearchBar(
              onSearch:
                  (query) => controller.productController.searchProducts(query),
            ),

            const SizedBox(height: UIConfig.paddingMedium),

            // Categories section
            SectionHeader(
              title: 'Categories',
              onSeeAllTap: () => controller.onCategoriesSeeAllTap(),
            ),

            SizedBox(
              height: 100,
              child: Obx(
                () => CategoryFilter(
                  categories: controller.categoryController.categories,
                  selectedCategoryId:
                      controller.categoryController.selectedCategoryId.value,
                  onCategorySelected:
                      (categoryId) => controller.categoryController
                          .selectCategoryById(categoryId),
                ),
              ),
            ),

            // Rest of your content...
            // Top Selling section and New In section remain the same

            // Top Selling section
            SectionHeader(
              title: 'Top Selling',
              onSeeAllTap: () => controller.onTopSellingSeeAllTap(),
            ),

            Obx(() {
              if (controller.productController.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary(context),
                  ),
                );
              }

              if (controller.productController.products.isEmpty) {
                return const SizedBox.shrink();
              }

              return ProductGrid(
                products: controller.productController.products,
                onProductTap: (productId) => controller.onProductTap(productId),
                onFavoriteTap:
                    (productId) =>
                        controller.productController.toggleFavorite(productId),
                isHorizontal: true,
              );
            }),

            // New In section
            SectionHeader(
              title: 'New In',
              onSeeAllTap: () => controller.onNewInSeeAllTap(),
            ),

            Obx(() {
              if (controller.productController.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary(context),
                  ),
                );
              }

              if (controller.productController.products.isEmpty) {
                return Center(
                  child: Text(
                    'No products found.',
                    style: TextStyle(color: AppColors.mutedForeground(context)),
                  ),
                );
              }

              return ProductGrid(
                products: controller.productController.products,
                onProductTap: (productId) => controller.onProductTap(productId),
                onFavoriteTap:
                    (productId) =>
                        controller.productController.toggleFavorite(productId),
                isHorizontal: true,
              );
            }),
          ],
        ),
      ),
    );
  }
}
