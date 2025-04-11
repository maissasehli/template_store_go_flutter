// lib/features/wishlist/views/wishlist_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:store_go/app/shared/controllers/navigation_controller.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/features/home/views/widgets/search_bar.dart';
import 'package:store_go/features/product/models/product_model.dart';
import 'package:store_go/features/wishlist/controllers/wishlist_controller.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final WishlistController wishlistController = Get.find<WishlistController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Wishlist',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (wishlistController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return wishlistController.wishlistItems.isEmpty 
            ? _buildEmptyWishlist() 
            : _buildWishlistWithItems(wishlistController);
      }),
    );
  }

  Widget _buildWishlistWithItems(WishlistController controller) {
    return Column(
      children: [
        const SizedBox(height: 12),
        CustomSearchBar(onSearch: controller.searchWishlistItems),
        const SizedBox(height: 40),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              itemCount: controller.wishlistItems.length,
              itemBuilder: (context, index) {
                return _buildWishlistItem(controller, index);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWishlistItem(WishlistController controller, int index) {
    final item = controller.wishlistItems[index];
    final product = controller.getProductDetails(item.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dynamic product image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: _getProductImage(product),
              fit: BoxFit.cover,
            ),
            
            ),
          ),
          const SizedBox(width: 12),
          
          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  product?.name ?? item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  product?.description ?? item.description,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${product?.finalPrice.toStringAsFixed(2) ?? item.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Close button and quantity selector
          Column(
            children: [
              InkWell(
                onTap: () => controller.removeFromWishlist(item.id),
                child: const Icon(Icons.close, size: 18),
              ),
              const SizedBox(height: 24),
              
              // Quantity selector
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => controller.updateItemQuantity(
                        item.id, 
                        item.quantity > 1 ? item.quantity - 1 : 1
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(Icons.remove, size: 16),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.quantity.toString(),
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () => controller.updateItemQuantity(
                        item.id, 
                        item.quantity + 1
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(Icons.add, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
// Helper method to determine the correct image to display
ImageProvider _getProductImage(ProductModels? product) {
  final imageUrl = product?.imageUrls;
  
  // Check if the image URL is a network URL or an asset path
  if (imageUrl != null && (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'))) {
    // It's a network image
    return NetworkImage(imageUrl);
  } else {
    // It's an asset image
    // Remove any 'file:///' prefix if it exists
    final assetPath = (imageUrl ?? '').replaceAll('file:///', '');
    return AssetImage(assetPath);
  }
}

  Widget _buildEmptyWishlist() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 94,
            height: 94,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF686868).withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 26.1,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                AssetConfig.heartIcon,
                width: 47,
                height: 44.65,
                colorFilter: const ColorFilter.mode(
                  Colors.grey,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No wishlist yet',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              final navController = Get.find<NavigationController>();
              navController.changeTab(0);
              Get.toNamed('/categories');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: const Text(
              'Explore Categories',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}