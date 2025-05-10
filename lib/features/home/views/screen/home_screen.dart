import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/services/connection_service.dart';
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
import 'package:store_go/features/home/views/widgets/skeleton_loaders.dart';

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
        await controller.productController.fetchAllProducts();
        await controller.productController.fetchFeaturedProducts();
        await controller.productController.fetchNewProducts();
      },
      color: AppColors.primary(context),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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

            _buildCategoriesSection(context),

            // Top Selling section
            SectionHeader(
              title: 'Top Selling',
              onSeeAllTap: () => controller.onTopSellingSeeAllTap(),
            ),

            _buildTopSellingSection(context),

            // New In section
            SectionHeader(
              title: 'New In',
              onSeeAllTap: () => controller.onNewInSeeAllTap(),
            ),

            _buildNewInSection(context),

            const SizedBox(height: UIConfig.paddingLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Obx(() {
        if (controller.categoryController.isLoading.value) {
          return const CategorySkeletonLoader();
        }

        return CategoryFilter(
          categories: controller.categoryController.categories,
          selectedCategoryId:
              controller.categoryController.selectedCategoryId.value,
          onCategorySelected:
              (categoryId) =>
                  controller.categoryController.selectCategoryById(categoryId),
        );
      }),
    );
  }

  Widget _buildTopSellingSection(BuildContext context) {
    return Obx(() {
      if (controller.productController.isLoadingFeatured.value) {
        return const ProductSkeletonLoader(isHorizontal: true);
      }

      if (controller.productController.featuredProducts.isEmpty) {
        return _buildEmptyState(context);
      }

      return ProductGrid(
        products: controller.productController.featuredProducts,
        onProductTap: (productId) => controller.onProductTap(productId),
        onFavoriteTap:
            (productId) =>
                controller.productController.toggleFavorite(productId),
        isHorizontal: true,
      );
    });
  }

  Widget _buildNewInSection(BuildContext context) {
    return Obx(() {
      if (controller.productController.isLoadingNew.value) {
        return const ProductSkeletonLoader(isHorizontal: true);
      }

      if (controller.productController.newProducts.isEmpty) {
        return _buildEmptyState(context);
      }

      return ProductGrid(
        products: controller.productController.newProducts,
        onProductTap: (productId) => controller.onProductTap(productId),
        onFavoriteTap:
            (productId) =>
                controller.productController.toggleFavorite(productId),
        isHorizontal: true,
      );
    });
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: UIConfig.paddingLarge),
        child: Column(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 48,
              color: AppColors.mutedForeground(context),
            ),
            const SizedBox(height: UIConfig.paddingSmall),
            Text(
              'No products found',
              style: TextStyle(
                color: AppColors.mutedForeground(context),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
