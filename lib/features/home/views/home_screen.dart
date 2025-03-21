import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/features/home/controllers/home_controller.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/core/theme/app_color_extension.dart';
import 'package:store_go/features/home/views/widgets/category_filter.dart';
import 'package:store_go/features/home/views/widgets/custom_app_bar.dart';
import 'package:store_go/features/home/views/widgets/product_grid.dart';
import 'package:store_go/features/home/views/widgets/search_bar.dart';

// Example for HomeScreen
class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final CategoryController categoryController = Get.find<CategoryController>();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorExtension>();

    return Scaffold(
      backgroundColor: colors?.background ?? Colors.white,
      appBar: CustomAppBar(
        onSearch: (query) => controller.productController.searchProducts(query),
      ),
      body: _buildContent(context, colors),
    );
  }

  Widget _buildContent(BuildContext context, AppColorExtension? colors) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: UIConfig.paddingMedium),
          // Add CustomSearchBar right after the AppBar
          CustomSearchBar(
            onSearch:
                (query) => controller.productController.searchProducts(query),
          ),

          const SizedBox(height: UIConfig.paddingMedium),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: UIConfig.paddingMedium,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Gabarito',
                  ),
                ),
                TextButton(
                  onPressed: () => controller.onCategoriesSeeAllTap(),
                  child: const Text(
                    'See All',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
                  ),
                ),
              ],
            ),
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
                        .selectCategory(categoryId),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: UIConfig.paddingMedium,
              vertical: UIConfig.paddingSmall,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Top Selling',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Gabarito',
                  ),
                ),
                TextButton(
                  onPressed: () => controller.onTopSellingSeeAllTap(),
                  child: const Text(
                    'See All',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
                  ),
                ),
              ],
            ),
          ),

          Obx(() {
            if (controller.productController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
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

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: UIConfig.paddingMedium,
              vertical: UIConfig.paddingSmall,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'New In',
                  style: TextStyle(
                    fontSize: UIConfig.fontSizeRegular,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => controller.onNewInSeeAllTap(),
                  child: const Text('See All'),
                ),
              ],
            ),
          ),

          Obx(() {
            if (controller.productController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.productController.products.isEmpty) {
              return const Center(child: Text('No products found.'));
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
    );
  }
}
