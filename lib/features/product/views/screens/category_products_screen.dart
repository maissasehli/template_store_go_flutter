import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/category/models/category.modal.dart';
import 'package:store_go/features/product/controllers/product_controller.dart';
import 'package:store_go/features/product/models/product_modal.dart';
import 'package:store_go/features/home/views/widgets/search_bar.dart';

class CategoryProductsScreen extends StatelessWidget {
  const CategoryProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the category passed as argument
    final Category category = Get.arguments as Category;
    final ProductController productController = Get.find<ProductController>();
    final RxString selectedSubcategory = ''.obs;

    // Fetch products for this category
    productController.fetchProductsByCategory(category.id);

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: AppColors.background(context),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // Back button
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.muted(context),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.foreground(context),
                  size: 20,
                ),
                onPressed: () => Get.back(),
                padding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(width: 12),
            // Search bar
            Expanded(
              child: CustomSearchBar(
                onSearch: (value) {
                  productController.searchProducts(value);
                },
              ),
            ),
          ],
        ),
        toolbarHeight: 70,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category title with product count
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Obx(
              () => Text(
                '${category.name} (${productController.isLoading.value ? "..." : productController.products.length})',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.foreground(context),
                ),
              ),
            ),
          ),

          // Subcategory filter chips - horizontal scrollable row
          Padding(
            padding: const EdgeInsets.only(left: 24, top: 16, bottom: 16),
            child: SizedBox(
              height: 32,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                // Obx enables reactive UI updates when selectedSubcategory changes
                child: Obx(
                  () => Row(
                    children: [
                      _buildFilterChip(
                        context,
                        'All',
                        selectedSubcategory.value.isEmpty,
                        () => selectedSubcategory.value = '',
                      ),
                      _buildFilterChip(
                        context,
                        'Shirt',
                        selectedSubcategory.value == 'Shirt',
                        () => selectedSubcategory.value = 'Shirt',
                      ),
                      _buildFilterChip(
                        context,
                        'Jacket',
                        selectedSubcategory.value == 'Jacket',
                        () => selectedSubcategory.value = 'Jacket',
                      ),
                      _buildFilterChip(
                        context,
                        'Shoes',
                        selectedSubcategory.value == 'Shoes',
                        () => selectedSubcategory.value = 'Shoes',
                      ),
                      _buildFilterChip(
                        context,
                        'Accessories',
                        selectedSubcategory.value == 'Accessories',
                        () => selectedSubcategory.value = 'Accessories',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Product grid - expanded to fill remaining space
          Expanded(
            // Obx makes this section reactive to changes in productController state
            child: Obx(() {
              // Show loading indicator while fetching products
              if (productController.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary(context),
                  ),
                );
              } else if (productController.products.isEmpty) {
                // Show message when no products are found
                return Center(
                  child: Text(
                    'No products found',
                    style: TextStyle(color: AppColors.mutedForeground(context)),
                  ),
                );
              }

              // Initialize products list with all products from controller
              List<Product> filteredProducts = productController.products;

              // Apply filtering based on selected subcategory
              if (selectedSubcategory.value.isNotEmpty) {
                filteredProducts =
                    productController.products.where((p) {
                      if (selectedSubcategory.value == 'Jacket') {
                        return p.name.toLowerCase().contains('jacket') ||
                            p.name.toLowerCase().contains('vest') ||
                            p.name.toLowerCase().contains('pullover');
                      } else if (selectedSubcategory.value == 'Shoes') {
                        return p.name.toLowerCase().contains('shoes') ||
                            p.name.toLowerCase().contains('slides');
                      } else if (selectedSubcategory.value == 'Shirt') {
                        return p.name.toLowerCase().contains('shirt') ||
                            p.name.toLowerCase().contains('tee');
                      } else if (selectedSubcategory.value == 'Accessories') {
                        return p.name.toLowerCase().contains('bag') ||
                            p.name.toLowerCase().contains('accessories');
                      }
                      return true;
                    }).toList();
              }

              // Build product grid with filtered products
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GridView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two products per row
                    childAspectRatio: 0.7, // Taller than wide for product cards
                    crossAxisSpacing: 16, // Horizontal spacing
                    mainAxisSpacing: 16, // Vertical spacing
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    return _buildProductCard(context, filteredProducts[index]);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Builds a filter chip for subcategory filtering
  Widget _buildFilterChip(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primary(context)
                  : AppColors.muted(context),
          borderRadius: BorderRadius.circular(100), // Fully rounded corners
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            color:
                isSelected
                    ? AppColors.primaryForeground(context)
                    : AppColors.mutedForeground(context),
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  /// Builds a product card widget for the grid
  Widget _buildProductCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () => Get.toNamed('/products/${product.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image with favorite button overlay
          Expanded(
            child: Stack(
              children: [
                // Product image with rounded corners
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: AppColors.card(context),
                    child: Image.network(
                      product.images.isNotEmpty
                          ? product.images.first
                          : 'https://via.placeholder.com/150',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          product.images.isNotEmpty
                              ? product.images.first.replaceAll('asset://', '')
                              : 'assets/placeholder.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: AppColors.mutedForeground(context),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                // Favorite button positioned on top right of image
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    height: 28,
                    width: 28,
                    decoration: BoxDecoration(
                      color: AppColors.card(context),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.foreground(
                            context,
                          ).withOpacity(0.05),
                          spreadRadius: 0,
                          blurRadius: 1,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        product.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 16,
                        color:
                            product.isFavorite
                                ? AppColors.destructive(context)
                                : AppColors.mutedForeground(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Product name
          Text(
            product.name,
            maxLines: 1,
            overflow:
                TextOverflow.ellipsis, // Truncate long names with ellipsis
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.mutedForeground(context),
            ),
          ),
          const SizedBox(height: 4),
          // Product price
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.foreground(context),
            ),
          ),
        ],
      ),
    );
  }
}
