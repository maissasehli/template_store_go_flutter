import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/search/no_search_result.dart';
import 'package:store_go/features/wishlist/controllers/wishlist_controller.dart';
import 'package:store_go/features/wishlist/models/wishlist_item_model.dart';
import 'package:store_go/features/wishlist/views/widget/empty_wishlist_view.dart';
import 'package:store_go/features/wishlist/views/widget/wishlist_header.dart';
import 'package:store_go/features/wishlist/views/widget/wishlist_item_tile.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistPage> {
  late WishlistController _wishlistController;

  @override
  void initState() {
    super.initState();
    
    // Get the instance of the controller
    _wishlistController = Get.find<WishlistController>();
    // Clear any temporary items
    _wishlistController.clearTemporaryItems();

    // Refresh the list
    _wishlistController.fetchWishlistItems();
  }

  // Filter items based on search text
  void _filterItems(String searchText) {
    _wishlistController.filterWishlistItems(searchText);
  }

  // Method to update item quantity (kept for UI functionality)
  void _updateQuantity(WishlistItemModel item, int delta) {
    // In this implementation, quantity is just a UI state
    // It's not sent to the server, as the API doesn't support quantity for wishlist
    // This functionality could be moved to a shopping cart feature in the future
  }

  // Method to remove item from wishlist
  void _removeItem(WishlistItemModel item) {
    _wishlistController.removeFromWishlist(item.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Wishlist',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        // Show loading indicator when loading
        if (_wishlistController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show error message when there's an error
        if (_wishlistController.hasError.value) {
          return _buildErrorView();
        }

        // Show empty state when wishlist is empty
        if (_wishlistController.wishlistItems.isEmpty) {
          return const EmptyWishlistView();
        }

        // Show wishlist items
        return _buildWishlistContent();
      }),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error: ${_wishlistController.errorMessage.value}'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _wishlistController.fetchWishlistItems(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistContent() {
    return Column(
      children: [
        // Wishlist header with search bar
        WishlistHeader(onSearch: _filterItems),

        // Wishlist items list
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(() {
              // No items after filtering (search with no results)
              if (_wishlistController.filteredWishlistItems.isEmpty && 
                  _wishlistController.wishlistItems.isNotEmpty) {
                return NoSearchResult(
                  onExploreCategories: () {
                    // Clear search and return to all items
                    _wishlistController.filterWishlistItems('');
                  },
                );
              }

              return ListView.builder(
                key: ValueKey(_wishlistController.filteredWishlistItems.length),
                itemCount: _wishlistController.filteredWishlistItems.length,
                itemBuilder: (context, index) {
                  final item = _wishlistController.filteredWishlistItems[index];
                  return WishlistItemTile(
                    key: ValueKey(item.id),
                    item: item,
                    onRemove: _removeItem,
                    onUpdateQuantity: _updateQuantity,
                  );
                },
              );
            }),
          ),
        ),
      ],
    );
  }
}