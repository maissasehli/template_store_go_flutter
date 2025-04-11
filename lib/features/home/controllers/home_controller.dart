import 'package:get/get.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/features/product/controllers/product_controller.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:store_go/features/product/repositories/product_repository.dart';
import 'package:store_go/features/wishlist/controllers/wishlist_controller.dart';
import 'package:store_go/features/wishlist/models/wishlist_item_model.dart';

class HomeController extends GetxController {
  final CategoryController categoryController = Get.find<CategoryController>();
  final ProductController productController = Get.put(
    ProductController(repository: ProductRepository(apiClient: ApiClient())),
  );
  late WishlistController _wishlistController;

  @override
  void onInit() {
    super.onInit();
    // Get the wishlist controller
    _wishlistController = Get.find<WishlistController>();
  }

  void onCategoriesSeeAllTap() {
    Get.toNamed(AppRoute.categories);
  }

  void onTopSellingSeeAllTap() {
    Get.toNamed(AppRoute.products, arguments: {'title': 'Top Selling'});
  }

  void onNewInSeeAllTap() {
    Get.toNamed(AppRoute.products, arguments: {'title': 'New In'});
  }

  void onProductTap(String productId) {
    Get.toNamed('/products/$productId');
  }

  // method to handle favorite toggling
  Future<void> toggleFavorite(String productId) async {
    try {
      // Get the current status
      final isAlreadyFavorite = isProductInWishlist(productId);

      // Optimistically update UI first
      if (isAlreadyFavorite) {
        // Remove from local wishlist immediately for UI update
        _wishlistController.wishlistItems.removeWhere(
          (item) => item.productId == productId,
        );
      } else {
        // Add a temporary entry to local wishlist for UI update
        final tempItem = WishlistItemModel(
          id: DateTime.now().toString(),
          storeId: '',
          appUserId: '',
          productId: productId,
          addedAt: DateTime.now(),
          product: ProductModel.empty(),
        );
        _wishlistController.wishlistItems.add(tempItem);
      }

      // Force UI refresh
      update();

      // Then perform the actual API call
      if (isAlreadyFavorite) {
        await _wishlistController.removeFromWishlist(productId);
      } else {
        await _wishlistController.addToWishlist(productId);
      }
    } catch (e) {
      // If there's an error, refresh the wishlist to sync with server
      await _wishlistController.fetchWishlistItems();
      print('Error toggling favorite status: $e');
    }
  }

  // Method to check if a product is in wishlist
  bool isProductInWishlist(String productId) {
    return _wishlistController.wishlistItems.any(
      (item) => item.productId == productId,
    );
  }
}
