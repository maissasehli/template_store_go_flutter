import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/features/home/controllers/home_controller.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/home/views/widgets/category_filter.dart';
import 'package:store_go/features/home/views/widgets/custom_app_bar.dart';
import 'package:store_go/features/home/views/widgets/product_grid.dart';
import 'package:store_go/features/promotion/views/widgets/promotion_banner.dart';
import 'package:store_go/features/home/views/widgets/search_bar.dart';
import 'package:store_go/features/home/views/widgets/section_header.dart';
import 'package:store_go/features/profile/controllers/profile_controller.dart';
import 'package:store_go/features/home/views/widgets/skeleton_loaders.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
import 'package:store_go/features/promotion/controller/promotion_controller.dart';
import 'package:store_go/features/promotion/models/promotion_model.dart';
import 'package:store_go/features/promotion/views/widgets/promotion_product_page.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final CategoryController categoryController = Get.find<CategoryController>();
  final ProfileController profileController = Get.find<ProfileController>();
  final PromotionController promotionController = Get.put(PromotionController(
    promotionRepository: Get.find(), // Assuming repository is already registered
  ));

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch home promotions when screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      promotionController.fetchHomePromotions();
    });

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
    return GestureDetector(
      // Dismiss keyboard when tapping anywhere on the screen
      onTap: () {
        // Unfocus any focused text field
        FocusScope.of(context).unfocus();
      },
      child: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            controller.productController.fetchAllProducts(),
            controller.productController.fetchFeaturedProducts(),
            controller.productController.fetchNewProducts(),
            promotionController.refreshHomePromotions(),
          ]);
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
                title: 'home.categories'.translate(),
                onSeeAllTap: () => controller.onCategoriesSeeAllTap(),
              ),

              _buildCategoriesSection(context),

              const SizedBox(height: UIConfig.paddingSmall),

              // Promotions Banner (only show if there are promotions with images)
              _buildPromotionsSection(context),

              // Top Selling section
              SectionHeader(
                title: 'home.top_selling'.translate(),
                onSeeAllTap: () => controller.onTopSellingSeeAllTap(),
              ),

              _buildTopSellingSection(context),

              // New In section
              SectionHeader(
                title: 'home.new_in'.translate(),
                onSeeAllTap: () => controller.onNewInSeeAllTap(),
              ),

              _buildNewInSection(context),

              const SizedBox(height: UIConfig.paddingLarge),
            ],
          ),
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

  Widget _buildPromotionsSection(BuildContext context) {
    return Obx(() {
      // Only show promotions banner if there are promotions with images
      if (!promotionController.hasHomePromotions) {
        return const SizedBox.shrink();
      }

      return PromotionBanner(
        promotions: promotionController.homePromotions,
        onPromotionTap: (promotion) => _navigateToPromotionProducts(promotion),
      );
    });
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
              'home.no_products_found'.translate(),
              style: LocalizationService.getLocalizedTextStyle(
                context,
                TextStyle(
                  color: AppColors.mutedForeground(context),
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Navigate to promotion products page
  void _navigateToPromotionProducts(Promotion promotion) {
    Get.to(() => PromotionProductsPage(promotion: promotion));
  }
}