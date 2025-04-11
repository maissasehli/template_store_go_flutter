import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/home/controllers/home_controller.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/home/views/widgets/category_list_view.dart';
import 'package:store_go/features/home/views/widgets/custom_app_bar.dart';
import 'package:store_go/features/home/views/widgets/product_card.dart';
import 'package:store_go/features/home/views/widgets/search_bar.dart';
import 'package:store_go/features/product/controllers/product_controller.dart';
import 'package:store_go/features/product/models/product_model.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
    final ProductController productController = Get.put(ProductControllerImp());  // Add this line


  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: CustomAppBar(actions: []),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: UIConfig.paddingMedium),

            // Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: UIConfig.paddingMedium),
              child: CustomSearchBar(
                onSearch: (query) => controller.searchProducts(query),
              ),
            ),

            const SizedBox(height: UIConfig.paddingMedium),

            // Category Title with See All button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: UIConfig.paddingMedium,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gabarito',
                      color: AppColors.foreground(context),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to the CategoryScreen when See All is clicked
                      Get.toNamed('/categories');
                    },
                    child: const Text('See All'),
                  )
                ],
              ),
            ),

            // Category Filter
            SizedBox(
              height: 100,
              child: Obx(
                () => CategoryListView(
                  categories: controller.categories,
                  selectedCategoryId: controller.selectedCategoryId.value,
                  onCategorySelected: (categoryId) {
                    controller.selectCategory(categoryId);
                  },
                ),
              ),
            ),

            const SizedBox(height: UIConfig.paddingMedium),

            // Top Selling Section Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: UIConfig.paddingMedium,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Top Selling',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gabarito',
                      color: AppColors.foreground(context),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.toNamed('/all-products', arguments: {'filter': 'top-selling'});
                    },
                    child: const Text('See All'),
                  )
                ],
              ),
            ),

            // Top Selling Products
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final topSellingProducts = controller.getTopSellingProducts();

              if (topSellingProducts.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'No top selling products available.',
                      style: TextStyle(color: AppColors.mutedForeground(context)),
                    ),
                  ),
                );
              }

              return ProductCard(
                products: topSellingProducts,
                isHorizontal: true,
               onProductTap: (id) => controller.navigateToProductDetail(id),

                onFavoriteTap: (id) => productController.toggleFavorite(id),

              );
            }),

            const SizedBox(height: UIConfig.paddingMedium),

            // New Arrivals Section Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: UIConfig.paddingMedium,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'New In',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gabarito',
                      color: AppColors.foreground(context),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.toNamed('/all-products', arguments: {'filter': 'new'});
                    },
                    child: const Text('See All'),
                  )
                ],
              ),
            ),

            // New Products
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final newProducts = controller.products
                  .where((product) => product.isNew)
                  .toList();

              if (newProducts.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'No new products available.',
                      style: TextStyle(color: AppColors.mutedForeground(context)),
                    ),
                  ),
                );
              }

              return ProductCard(
                products: newProducts,
                isHorizontal: true,
                 onProductTap: (id) => controller.navigateToProductDetail(id),

                onFavoriteTap: (String productId) {
                  productController.toggleFavorite(productId);
                },
              );
            }),

            // Add padding at the bottom
            const SizedBox(height: UIConfig.paddingLarge),
          ],
        ),
      ),
    );
  }
}