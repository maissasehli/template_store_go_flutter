import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/features/product/controllers/product_list_controller.dart';
import 'package:store_go/features/filter/controllers/product_filter_controller.dart';
import 'package:store_go/features/product/models/product_model.dart';
import 'package:store_go/features/product/controllers/product_controller.dart';
import 'package:store_go/features/home/views/widgets/product_card.dart';
import 'package:store_go/features/home/views/widgets/skeleton_loaders.dart';
import 'package:store_go/features/home/views/widgets/search_bar.dart';
import 'package:store_go/features/filter/view/screen/filter_product_sheet.dart';
import 'package:store_go/features/subcategory/controllers/subcategory_controller.dart';

class ProductListScreen extends StatelessWidget {
  final ProductController productController = Get.find<ProductController>();
  late final ProductFilterController filterController;
  late final ProductListController listController;
  final CategoryController categoryController = Get.find<CategoryController>();
  final SubcategoryController subcategoryController = Get.find<SubcategoryController>();

  ProductListScreen({super.key}) {
    // Initialize controllers
    filterController = Get.put(
      ProductFilterController(productController: productController),
    );
    
    listController = Get.put(
      ProductListController(
        productController: productController,
        filterController: filterController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background(context),
      elevation: 0,
      centerTitle: true,
      title: Obx(
        () => Text(
          listController.title.value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.foreground(context),
          ),
        ),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: AppColors.foreground(context),
          size: 20,
        ),
        onPressed: () => Get.back(),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.filter_list_rounded,
            color: AppColors.foreground(context),
            size: 24,
          ),
          onPressed: () => _showFilterBottomSheet(context),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: UIConfig.paddingSmall,
            bottom: UIConfig.paddingMedium,
          ),
          child: CustomSearchBar(
            onSearch: (query) => productController.searchProducts(query),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => listController.refreshProducts(),
            color: AppColors.primary(context),
            child: Obx(() {
              if (listController.isLoading.value) {
                return const _LoadingGrid();
              }

              if (listController.hasError.value) {
                return _buildErrorView(context);
              }

              if (listController.products.isEmpty) {
                return _buildEmptyView(context);
              }

              return _buildProductGrid(context);
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildProductGrid(BuildContext context) {
    return Obx(
      () => GridView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: UIConfig.paddingMedium,
          vertical: UIConfig.paddingSmall,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: listController.products.length,
        itemBuilder: (context, index) {
          final product = listController.products[index];
          return _buildProductCard(context, product);
        },
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    return ProductCard(
      product: product,
      onProductTap: (id) => listController.onProductTap(id),
      onFavoriteTap: (id) => listController.toggleFavorite(id),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 64,
            color: AppColors.mutedForeground(context),
          ),
          const SizedBox(height: UIConfig.paddingMedium),
          Text(
            'No products found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.mutedForeground(context),
            ),
          ),
          const SizedBox(height: UIConfig.paddingSmall),
          Text(
            'Try adjusting your filters',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.mutedForeground(context),
            ),
          ),
          const SizedBox(height: UIConfig.paddingLarge),
          ElevatedButton(
            onPressed: () => listController.clearFilters(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary(context),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: UIConfig.paddingLarge,
                vertical: UIConfig.paddingSmall,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  UIConfig.borderRadiusMedium,
                ),
              ),
            ),
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: UIConfig.paddingMedium),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: UIConfig.paddingLarge,
            ),
            child: Text(
              listController.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.mutedForeground(context),
              ),
            ),
          ),
          const SizedBox(height: UIConfig.paddingLarge),
          ElevatedButton(
            onPressed: () => listController.refreshProducts(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary(context),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: UIConfig.paddingLarge,
                vertical: UIConfig.paddingSmall,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  UIConfig.borderRadiusMedium,
                ),
              ),
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        listController: listController,
        filterController: filterController,
        categoryController: categoryController,
        subcategoryController: subcategoryController,
      ),
    );
  }
}

class _LoadingGrid extends StatelessWidget {
  const _LoadingGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: UIConfig.paddingMedium,
        vertical: UIConfig.paddingSmall,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: 6,
      itemBuilder: (context, index) {
        return _buildProductSkeletonCard();
      },
    );
  }

  Widget _buildProductSkeletonCard() {
    return Container(
      width: 160,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final imageHeight = constraints.maxWidth * 0.8;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SkeletonContainer.circular(
                width: constraints.maxWidth,
                height: imageHeight,
                radius: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(UIConfig.paddingSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SkeletonContainer.rectangular(
                      width: constraints.maxWidth * 0.75,
                      height: 14,
                    ),
                    const SizedBox(height: 6),
                    SkeletonContainer.rectangular(
                      width: constraints.maxWidth * 0.5,
                      height: 12),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SkeletonContainer.rectangular(
                          width: constraints.maxWidth * 0.45,
                          height: 10,
                        ),
                        SkeletonContainer.circular(
                          width: 20,
                          height: 20,
                          radius: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}