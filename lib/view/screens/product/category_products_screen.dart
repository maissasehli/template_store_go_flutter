import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/controller/product/product_controller.dart';
import 'package:store_go/core/model/home/category_model.dart';
import 'package:store_go/core/model/home/product_model.dart';
import 'package:store_go/view/widgets/home/search_bar.dart';

class CategoryProductsScreen extends StatelessWidget {
  const CategoryProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Category category = Get.arguments;
    final ProductController productController = Get.find<ProductController>();
    final RxString selectedSubcategory = ''.obs;

    productController.fetchProductsByCategory(category.id);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // Back button
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFF4F4F4),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
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
      // Rest of your original code remains the same
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category title with product count
          Padding(
            padding: const EdgeInsets.only(left: 27),
            child: Text(
              '${category.name} (${category.productCount ?? 0})',
              style: const TextStyle(
                fontFamily: 'Gabarito',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                height: 1.0,
                letterSpacing: 0,
                color: Colors.black,
              ),
            ),
        
          ),
          
          // Subcategory filter chips - horizontal scrollable row
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 15),
            child: Container(
              height: 30,
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                // Obx enables reactive UI updates when selectedSubcategory changes
                child: Obx(() => Row(
                  children: [
                    _buildFilterChip('Shirt', selectedSubcategory.value == 'Shirt', 
                      () => selectedSubcategory.value = 'Shirt'),
                    _buildFilterChip('Jacket', selectedSubcategory.value == 'Jacket', 
                      () => selectedSubcategory.value = 'Jacket'),
                    _buildFilterChip('Shoes', selectedSubcategory.value == 'Shoes', 
                      () => selectedSubcategory.value = 'Shoes'),
                    _buildFilterChip('Accessories', selectedSubcategory.value == 'Accessories', 
                      () => selectedSubcategory.value = 'Accessories'),
                  ],
                )),
              ),
            ),
          ),
          const SizedBox(height: 15),

          // Product grid - expanded to fill remaining space
          Expanded(
            // Obx makes this section reactive to changes in productController state
            child: Obx(() {
              // Show loading indicator while fetching products
              if (productController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (productController.products.isEmpty) {
                // Show message when no products are found
                return const Center(child: Text('No products found'));
              }

              // Initialize products list with all products from controller
              List<Product> filteredProducts = productController.products;
              
              // Apply filtering based on selected subcategory
              if (selectedSubcategory.value.isNotEmpty) {
                filteredProducts = productController.products.where((p) {
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
                padding: const EdgeInsets.only(left: 27, right: 27),
                child: Container(
                  width: 342,
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Two products per row
                      childAspectRatio: 0.7, // Taller than wide for product cards
                      crossAxisSpacing: 20, // Horizontal spacing
                      mainAxisSpacing: 20, // Vertical spacing
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      return _buildProductCard(filteredProducts[index]);
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Builds a filter chip for subcategory filtering
  /// @param label The text to display on the chip
  /// @param isSelected Whether this chip is currently selected
  /// @param onTap Function to call when the chip is tapped
  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white, // Black when selected, white when not
          borderRadius: BorderRadius.circular(100), // Fully rounded corners
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Gabarito',
            color: isSelected ? Colors.white : Colors.black, // Text color changes based on selection
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  /// Builds a product card widget for the grid
  /// @param product The product data to display
  Widget _buildProductCard(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product image with favorite button overlay
        Stack(
          children: [
            // Product image with rounded corners
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 0.9,
                child: Image.asset(
                  product.images.isNotEmpty 
                      ? product.images.first.replaceAll('asset://', '') 
                      : 'assets/placeholder.png',
                  fit: BoxFit.cover,
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
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 0,
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    product.isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 16,
                    color: product.isFavorite ? Colors.black : Colors.grey[400],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Product name
        Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis, // Truncate long names with ellipsis
          style: const TextStyle(
            fontFamily: 'Gabarito',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        // Product price
        Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: const TextStyle(
            fontFamily: 'Gabarito',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}