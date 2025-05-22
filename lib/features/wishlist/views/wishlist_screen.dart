import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/search/no_search_result.dart';
import 'package:store_go/features/wishlist/controllers/wishlist_controller.dart';
import 'package:store_go/features/wishlist/models/wishlist_item_model.dart';
import 'package:store_go/features/wishlist/views/widget/empty_wishlist_view.dart';
import 'package:store_go/features/wishlist/views/widget/wishlist_header.dart';
import 'package:store_go/features/wishlist/views/widget/wishlist_item_card.dart'; // Updated import
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/localization/localization_service.dart';

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

  // Method to remove item from wishlist
  void _removeItem(WishlistItemModel item) {
    _wishlistController.removeFromWishlist(item.productId);
  }

  // Navigate to product details
  void _onItemTap(WishlistItemModel item) {
    Get.toNamed('/products/${item.productId}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: AppColors.background(context),
        elevation: 0,
        title: Text(
          'wishlist.title'.translate(),
          style: LocalizationService.getLocalizedTextStyle(
            context,
            Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.foreground(context),
                  fontWeight: FontWeight.w500,
                ) ??
                TextStyle(
                  color: AppColors.foreground(context),
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        // Dismiss keyboard when tapping anywhere on the screen
        onTap: () => FocusScope.of(context).unfocus(),
        child: Obx(() {
          // Show loading indicator when loading
          if (_wishlistController.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primary(context),
              ),
            );
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
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${'wishlist.error_loading'.translate()}${_wishlistController.errorMessage.value}',
            style: LocalizationService.getLocalizedTextStyle(
              context,
              Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.destructive(context),
                  ) ??
                  TextStyle(color: AppColors.destructive(context)),
            ),
          ),
          const SizedBox(height: UIConfig.paddingMedium),
          ElevatedButton(
            onPressed: () => _wishlistController.fetchWishlistItems(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary(context),
              foregroundColor: AppColors.primaryForeground(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  UIConfig.borderRadiusCircular,
                ),
              ),
            ),
            child: Text(
              'common.retry'.translate(),
              style: LocalizationService.getLocalizedTextStyle(
                context,
                Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryForeground(context),
                    ) ??
                    TextStyle(color: AppColors.primaryForeground(context)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistContent() {
    final bool isRtl = LocalizationService.isRtl(context);

    return Column(
      crossAxisAlignment:
          isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        // Wishlist header with search bar
        WishlistHeader(onSearch: _filterItems),

        // Wishlist items list
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: UIConfig.paddingMedium,
            ),
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
                  return WishlistItemCard(
                    key: ValueKey(item.id),
                    item: item,
                    onRemove: _removeItem,
                    onTap: _onItemTap,
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
