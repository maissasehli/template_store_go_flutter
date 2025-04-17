import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/product/repositories/product_repository.dart';
import 'package:store_go/features/product/state/product_detail_state.dart';
import 'package:store_go/features/cart/controllers/cart_controller.dart';
import 'package:store_go/features/product/models/product_modal.dart';

class ProductDetailController extends GetxController {
  final ProductRepository _repository;
  final ProductDetailState state = ProductDetailState();
  final Logger _logger = Logger();

  ProductDetailController({required ProductRepository repository})
      : _repository = repository;

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
      _logger.i('Product reviews: ${product.reviews.map((r) => r.toJson()).toList()}');
      state.setProduct(product);

      _initializeProductOptions();
    } catch (e) {
      state.setError('Error fetching product details: $e');
      _logger.e('Error fetching product details: $e');
    } finally {
      state.setLoading(false);
    }
  }

  void _initializeProductOptions() {
    final product = state.product.value;
    if (product == null) return;

    _logger.i('Product: ${product.name}, Variants: ${product.variants}');
    
    if (product.variants.containsKey('color') && 
        product.variants['color']!.isNotEmpty) {
      final defaultColor = product.variants['color']![0]; // Now correctly "black"
      _logger.i('Setting default color: $defaultColor');
      state.setSelectedColor(defaultColor);
    } else {
      _logger.w('No colors available for this product');
      state.setSelectedColor('');
    }

    if (product.variants.containsKey('size') && 
        product.variants['size']!.isNotEmpty) {
      final defaultSize = product.variants['size']![0];
      _logger.i('Setting default size: $defaultSize');
      state.setSelectedSize(defaultSize);
    } else {
      _logger.w('No sizes available for this product');
      state.setSelectedSize('');
    }

    state.setQuantity(1);
    state.setCurrentImageIndex(0);
  }

  void updateSize(String size) {
    state.setSelectedSize(size);
  }

  void updateColor(String color) {
    state.setSelectedColor(color);
  }

  void updateQuantity(int value) {
    if (value < 1) value = 1;
    final product = state.product.value;
    if (product != null && value > product.stockQuantity) {
      value = product.stockQuantity;
    }
    state.setQuantity(value);
  }

  void updateImageIndex(int index) {
    if (state.product.value == null) return;
    final imageCount = state.product.value!.images.length;
    if (index >= 0 && index < imageCount) {
      state.setCurrentImageIndex(index);
    }
  }

  Future<void> toggleFavorite() async {
    if (state.product.value == null) return;

    final productId = state.product.value!.id;
    final currentStatus = state.product.value!.isFavorite;

    state.setProduct(state.product.value!.copyWith(isFavorite: !currentStatus));

    try {
      final success = await _repository.updateFavoriteStatus(
        productId,
        !currentStatus,
      );

      if (!success) {
        state.setProduct(
          state.product.value!.copyWith(isFavorite: currentStatus),
        );
      }
    } catch (e) {
      state.setProduct(
        state.product.value!.copyWith(isFavorite: currentStatus),
      );
      _logger.e('Error updating favorite status: $e');
    }
  }

  Future<void> addToCart() async {
    if (state.product.value == null) return;

    try {
      final product = state.product.value!;
      final quantity = state.quantity.value;

      Map<String, String> variants = {};
      if (state.selectedSize.value.isNotEmpty) {
        variants['size'] = state.selectedSize.value;
      }
      if (state.selectedColor.value.isNotEmpty) {
        variants['color'] = state.selectedColor.value;
      }

      final cartController = Get.find<CartController>();
      await cartController.addToCart(
        product: product,
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