import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/product/repositories/product_repository.dart';
import 'package:store_go/features/product/state/product_detail_state.dart';
import 'package:store_go/features/cart/controllers/cart_controller.dart';

/// Controller responsible for managing product details
class ProductDetailController extends GetxController {
  final ProductRepository _repository;
  final ProductDetailState state = ProductDetailState();
  final Logger _logger = Logger();

  ProductDetailController({required ProductRepository repository})
      : _repository = repository;

  /// Fetches product details by ID
  Future<void> fetchProductDetails(String productId) async {
    try {
      state.setLoading(true);
      state.clearError();
      state.clearProduct();

      final product = await _repository.getProductById(
        productId,
        forceRefresh: true,
      );

      _logger.i('Fetched product: ${product.toJson()}');
      state.setProduct(product);

      // Initialize product options once product is loaded
      _initializeProductOptions();
    } catch (e) {
      state.setError('Error fetching product details: $e');
      _logger.e('Error fetching product details: $e');
    } finally {
      state.setLoading(false);
    }
  }

  /// Initializes product options once product is loaded
  void _initializeProductOptions() {
    final product = state.product.value;
    if (product == null) return;

    // Set default color if available in variants
    if (product.variants.containsKey('color') &&
        product.variants['color']!.isNotEmpty) {
      state.setSelectedColor(product.variants['color']![0]);
    }

    // Set default size if available in variants
    if (product.variants.containsKey('size') &&
        product.variants['size']!.isNotEmpty) {
      state.setSelectedSize(product.variants['size']![0]);
    }

    // Reset quantity and image index
    state.setQuantity(1);
    state.setCurrentImageIndex(0);
  }

  /// Updates selected size
  void updateSize(String size) {
    state.setSelectedSize(size);
  }

  /// Updates selected color
  void updateColor(String color) {
    state.setSelectedColor(color);
  }

  /// Updates quantity
  void updateQuantity(int value) {
    // Ensure quantity is at least 1
    if (value < 1) value = 1;

    // Optionally limit by available stock
    final product = state.product.value;
    if (product != null && value > product.stockQuantity) {
      value = product.stockQuantity;
    }

    state.setQuantity(value);
  }

  /// Updates current image index
  void updateImageIndex(int index) {
    if (state.product.value == null) return;

    // Ensure index is within bounds
    final imageCount = state.product.value!.images.length;
    if (index >= 0 && index < imageCount) {
      state.setCurrentImageIndex(index);
    }
  }

  /// Toggles favorite status for the current product
  Future<void> toggleFavorite() async {
    if (state.product.value == null) return;

    final productId = state.product.value!.id;
    final currentStatus = state.product.value!.isFavorite;

    // Update UI optimistically
    state.setProduct(state.product.value!.copyWith(isFavorite: !currentStatus));

    try {
      // Send update to API
      final success = await _repository.updateFavoriteStatus(
        productId,
        !currentStatus,
      );

      // If API call failed, revert the changes
      if (!success) {
        state.setProduct(
          state.product.value!.copyWith(isFavorite: currentStatus),
        );
      }
    } catch (e) {
      // If there was an error, revert the changes
      state.setProduct(
        state.product.value!.copyWith(isFavorite: currentStatus),
      );
      _logger.e('Error updating favorite status: $e');
    }
  }

  /// Adds current product to cart with selected options
  Future<void> addToCart() async {
    if (state.product.value == null) return;

    try {
      final productId = state.product.value!.id;
      final quantity = state.quantity.value;

      Map<String, String> variants = {};

      // Add selected variants to options
      if (state.selectedSize.value.isNotEmpty) {
        variants['size'] = state.selectedSize.value;
      }

      if (state.selectedColor.value.isNotEmpty) {
        variants['color'] = state.selectedColor.value;
      }

      // Get cart controller and add item
      final cartController = Get.find<CartController>();
      await cartController.addToCart(
        productId: productId,
        quantity: quantity,
        variants: variants,
      );

      Get.snackbar(
        'Success',
        'Added to cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add item to cart',
        snackPosition: SnackPosition.BOTTOM,
      );
      _logger.e('Error adding to cart: $e');
    }
  }
}