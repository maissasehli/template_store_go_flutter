import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/home/views/widgets/product_card.dart';
import 'package:store_go/features/product/controllers/product_controller.dart';
import 'package:store_go/features/home/views/widgets/search_bar.dart';
import 'package:store_go/features/search/no_search_result.dart';
import 'package:store_go/features/product/views/widgets/list_category_product.dart';

class ProductScreen extends StatelessWidget {
  final productController = Get.put(ProductControllerImp());
  
  ProductScreen({Key? key}) : super(key: key);
  
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
                      onSearch: (query) {
                        productController.searchProducts(query);
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Category filter horizontal list
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: ListCategoryProduct(),
            ),

            // Results count text
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
              child: Obx(
                () => Text(
                  '${productController.filteredProducts.length} Results Found',
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // Products grid using ProductCard widget
            Expanded(
              child: Obx(() {
                if (productController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black87, // Primary app color
                    ),
                  );
                }

                if (productController.filteredProducts.isEmpty) {
                  return NoSearchResult(
                    onExploreCategories: () {
                      productController.resetFilter();
                    },
                  );
                }

                // Using the updated ProductCard widget for a proper grid layout
                return ProductCard(
                  products: productController.filteredProducts,
                 onProductTap: (id) => productController.navigateToProductDetail(id),
                  onFavoriteTap: (id) => productController.toggleFavorite(id),
                  isHorizontal: false,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}