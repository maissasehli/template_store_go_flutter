import 'package:get/get.dart';
import 'package:store_go/features/wishlist/models/wishlist_item_model.dart';
import 'package:store_go/features/wishlist/repositories/wishlist_repository.dart';

class WishlistController extends GetxController {
  final WishlistRepository _repository;

  // Observable state
  final RxList<WishlistItemModel> wishlistItems = <WishlistItemModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // For search functionality
  final RxList<WishlistItemModel> filteredWishlistItems =
      <WishlistItemModel>[].obs;

  WishlistController({required WishlistRepository repository})
    : _repository = repository;

  @override
  void onInit() {
    super.onInit();
    fetchWishlistItems();
  }

  Future<void> fetchWishlistItems() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final items = await _repository.getWishlistItems();
      wishlistItems.value = items;
      filteredWishlistItems.value = items;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToWishlist(String productId, {ProductModel? product}) async {
    try {
      // Only add temporary item if we have some product info
      if (product != null) {
        // Create a more complete temporary item
        final tempItem = WishlistItemModel(
          id: DateTime.now().toString(), // Temporary ID
          storeId: '',
          appUserId: '',
          productId: productId,
          addedAt: DateTime.now(),
          product: product, // Use the provided product info instead of empty
        );

        wishlistItems.add(tempItem);
        filteredWishlistItems.add(tempItem);
      }

      // Send to server
      await _repository.addToWishlist(productId);

      // After successful API call, refresh the list to get complete data
      await fetchWishlistItems();
    } catch (e) {
      // If failed, remove from local state
      wishlistItems.removeWhere((item) => item.productId == productId);
      filteredWishlistItems.removeWhere((item) => item.productId == productId);

      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }

  Future<void> removeFromWishlist(String productId) async {
    final itemsToRemove =
        wishlistItems.where((item) => item.productId == productId).toList();
    try {
      // Update local state first (optimistic update)
      wishlistItems.removeWhere((item) => item.productId == productId);
      filteredWishlistItems.removeWhere((item) => item.productId == productId);

      // Then send to server
      await _repository.removeFromWishlist(productId);
    } catch (e) {
      // If failed, restore the removed items
      wishlistItems.addAll(itemsToRemove);
      filteredWishlistItems.addAll(itemsToRemove);

      hasError.value = true;
      errorMessage.value = e.toString();

      // Optional: Refresh list to ensure consistency with server
      await fetchWishlistItems();
    }
  }

  void filterWishlistItems(String searchText) {
    if (searchText.isEmpty) {
      filteredWishlistItems.value = wishlistItems;
    } else {
      filteredWishlistItems.value =
          wishlistItems.where((item) {
            return item.product.name.toLowerCase().contains(
                  searchText.toLowerCase(),
                ) ||
                (item.product.description?.toLowerCase().contains(
                      searchText.toLowerCase(),
                    ) ??
                    false);
          }).toList();
    }
  }

  bool isProductInWishlist(String productId) {
    return wishlistItems.any((item) => item.productId == productId);
  }

  void clearTemporaryItems() {
    wishlistItems.removeWhere(
      (item) => item.product.name.isEmpty || item.product.price <= 0,
    );
    filteredWishlistItems.removeWhere(
      (item) => item.product.name.isEmpty || item.product.price <= 0,
    );
  }
}
