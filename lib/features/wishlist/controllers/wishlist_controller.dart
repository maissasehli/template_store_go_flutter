// lib/features/wishlist/controllers/wishlist_controller.dart
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/wishlist/model/wishlist_item_model.dart';
import 'package:store_go/features/wishlist/services/wishlist_api_service.dart';

class WishlistController extends GetxController {
  final WishlistApiService _apiService;
  final Logger _logger = Logger();

  // Observable state variables
  final RxList<WishlistItem> wishlistItems = <WishlistItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;

  WishlistController(this._apiService);

  @override
  void onInit() {
    super.onInit();
    fetchWishlistItems();
  }

  // Fetch wishlist items
  Future<void> fetchWishlistItems() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _apiService.getWishlistItems();
      final List<dynamic>? itemsData = response.data?['data'];

      if (itemsData == null || itemsData.isEmpty) {
        _logger.w('No wishlist items found');
        wishlistItems.clear();
      } else {
        wishlistItems.value = itemsData
            .map((json) => WishlistItem.fromJson(json))
            .toList();
      }
    } catch (e) {
      _handleError(e, 'Failed to load wishlist');
    } finally {
      isLoading.value = false;
    }
  }

  // Add item to wishlist
  Future<void> addToWishlist(WishlistItem item) async {
    try {
      isLoading.value = true;
      await _apiService.addToWishlist(item);
      await fetchWishlistItems();
    } catch (e) {
      _handleError(e, 'Failed to add item to wishlist');
    } finally {
      isLoading.value = false;
    }
  }

  // Remove item from wishlist
  Future<void> removeFromWishlist(String itemId) async {
    try {
      isLoading.value = true;
      await _apiService.removeFromWishlist(itemId);
      await fetchWishlistItems();
    } catch (e) {
      _handleError(e, 'Failed to remove item from wishlist');
    } finally {
      isLoading.value = false;
    }
  }

  // Update item quantity
  Future<void> updateItemQuantity(String itemId, int quantity) async {
    try {
      isLoading.value = true;
      await _apiService.updateWishlistItemQuantity(itemId, quantity);
      await fetchWishlistItems();
    } catch (e) {
      _handleError(e, 'Failed to update item quantity');
    } finally {
      isLoading.value = false;
    }
  }

  // Search wishlist items
  void searchWishlistItems(String query) {
    searchQuery.value = query;

    if (query.isEmpty) {
      fetchWishlistItems();
      return;
    }

    final filteredItems = wishlistItems.where((item) =>
        item.name.toLowerCase().contains(query.toLowerCase()) ||
        item.description.toLowerCase().contains(query.toLowerCase())
    ).toList();

    wishlistItems.value = filteredItems;
  }

  // Centralized error handling
  void _handleError(dynamic error, String context) {
    String errorDetail = error.toString();
    _logger.e('$context: $errorDetail');
    errorMessage.value = context;
  }
}