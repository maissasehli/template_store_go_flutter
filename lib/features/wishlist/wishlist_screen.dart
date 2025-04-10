// lib/features/wishlist/views/wishlist_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:store_go/app/shared/controllers/navigation_controller.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/features/home/views/widgets/search_bar.dart';
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

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Row(
        children: [
          // Product image placeholder
          Container(
            width: 70,
            height: 70,
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Image.asset(
              'assets/products/tshirt_white.png', 
              fit: BoxFit.cover,
            ),
          ),

          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  item.description,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 11,
                  ),
                ),
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Quantity and remove controls
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.close, size: 16),
                onPressed: () => controller.removeFromWishlist(item.id),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 16),
                      onPressed: () => controller.updateItemQuantity(
                        item.id, 
                        item.quantity > 1 ? item.quantity - 1 : 1
                      ),
                    ),
                    Text(item.quantity.toString()),
                    IconButton(
                      icon: const Icon(Icons.add, size: 16),
                      onPressed: () => controller.updateItemQuantity(
                        item.id, 
                        item.quantity + 1
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