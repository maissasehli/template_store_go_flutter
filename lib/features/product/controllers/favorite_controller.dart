import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/product/models/product_modal.dart';
import 'package:store_go/features/product/repositories/product_repository.dart';

/// Controller responsible for managing favorite products functionality
class FavoriteController extends GetxController {
  final ProductRepository _productRepository = Get.find<ProductRepository>();
  final Logger _logger = Logger();

  final RxList<Product> favoriteProducts = <Product>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFavoriteProducts();
  }

  /// Fetches the user's favorite products
  Future<void> fetchFavoriteProducts() async {
    try {
      isLoading.value = true;

      // You may need to create a specific endpoint for this
      final allProducts = await _productRepository.getAllProducts();
      final favorites = allProducts.where((p) => p.isFavorite).toList();

      favoriteProducts.assignAll(favorites);
    } catch (e) {
      _logger.e('Error fetching favorite products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Toggles favorite status for a product
  Future<void> toggleFavorite(String productId) async {
    // Find if product exists in favorites
    final index = favoriteProducts.indexWhere((p) => p.id == productId);
    final isFavorite = index != -1;

    // If it's in favorites, we're removing it
    if (isFavorite) {
      final product = favoriteProducts[index];
      favoriteProducts.removeAt(index);

      try {
        final success = await _productRepository.updateFavoriteStatus(
          productId,
          false,
        );

        // If API call failed, revert the change
        if (!success) {
          favoriteProducts.add(product);
        }
      } catch (e) {
        // If there was an error, revert the change
        favoriteProducts.add(product);
        _logger.e('Error removing favorite: $e');
      }
    }
    // If it's not in favorites, we need to add it
    else {
      try {
        final product = await _productRepository.getProductById(productId);
        final updatedProduct = product.copyWith(isFavorite: true);

        // Update UI optimistically
        favoriteProducts.add(updatedProduct);

        final success = await _productRepository.updateFavoriteStatus(
          productId,
          true,
        );

        // If API call failed, revert the change
        if (!success) {
          favoriteProducts.removeWhere((p) => p.id == productId);
        }
      } catch (e) {
        // If there was an error, revert the change
        favoriteProducts.removeWhere((p) => p.id == productId);
        _logger.e('Error adding favorite: $e');
      }
    }
  }
}
