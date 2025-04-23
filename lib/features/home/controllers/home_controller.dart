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
    _wishlistController = Get.find<WishlistController>();
  }

  void onCategoriesSeeAllTap() {
    Get.toNamed(AppRoute.categories);
  }
void onTopSellingSeeAllTap() {
  Get.toNamed(AppRoute.products, arguments: {
    'title': 'Top Selling',
    'listType': 'featured', // Matches the 'featured' case in ProductListController
  });
}

void onNewInSeeAllTap() {
  Get.toNamed(AppRoute.products, arguments: {
    'title': 'New In',
    'listType': 'new', // Matches the 'new' case in ProductListController
  });
}

  void onProductTap(String productId) {
    Get.toNamed(AppRoute.productDetail.replaceAll(':id', productId));
  }

  Future<void> toggleFavorite(String productId) async {
    try {
      final isAlreadyFavorite = isProductInWishlist(productId);

      if (isAlreadyFavorite) {
        _wishlistController.wishlistItems.removeWhere(
          (item) => item.productId == productId,
        );
      } else {
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

      update();

      if (isAlreadyFavorite) {
        await _wishlistController.removeFromWishlist(productId);
      } else {
        await _wishlistController.addToWishlist(productId);
      }
    } catch (e) {
      await _wishlistController.fetchWishlistItems();
    }
  }

  bool isProductInWishlist(String productId) {
    return _wishlistController.wishlistItems.any(
      (item) => item.productId == productId,
    );
  }
}