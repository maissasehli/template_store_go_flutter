import 'dart:math';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/product/repositories/product_repository.dart';
import 'package:store_go/features/product/state/product_detail_state.dart';
import 'package:store_go/features/cart/controllers/cart_controller.dart';
import 'package:store_go/features/review/model/review_model.dart';
import 'package:store_go/features/review/repositories/review_repository.dart';

class ProductDetailController extends GetxController {
  final ProductRepository _productRepository;
  final ReviewRepository _reviewRepository;
  final ProductDetailState state = ProductDetailState();
  final Logger _logger = Logger();

  ProductDetailController({
    required ProductRepository repository,
    required ReviewRepository reviewRepository,
  }) : _productRepository = repository,
       _reviewRepository = reviewRepository;

  Future<void> fetchProductDetails(String productId) async {
    try {
      state.setLoading(true);
      state.clearError();
      state.clearProduct();

      final product = await _productRepository.getProductById(
        productId,
        forceRefresh: true,
      );

      _logger.d('Fetched product: ${product.toJson()}');
      _logger.d(
        'Product reviews: ${product.reviews.map((r) => r.toJson()).toList()}',
      );
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

    _logger.d('Product: ${product.name}, Variants: ${product.variants}');

    if (product.variants.containsKey('color') &&
        product.variants['color']!.isNotEmpty) {
      final defaultColor = product.variants['color']![0];
      _logger.d('Setting default color: $defaultColor');
      state.setSelectedColor(defaultColor);
    } else {
      _logger.w('No colors available for this product');
      state.setSelectedColor('');
    }

    if (product.variants.containsKey('size') &&
        product.variants['size']!.isNotEmpty) {
      final defaultSize = product.variants['size']![0];
      _logger.d('Setting default size: $defaultSize');
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
      final success = await _productRepository.updateFavoriteStatus(
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

  Future<void> addReview(Review review) async {
    if (state.product.value == null) return;
    final productId = state.product.value!.id;

    try {
      // Add review through ReviewRepository
      final success = await _reviewRepository.createReview(productId, review);

      if (success) {
        // Update the product with the new review
        final updatedReviews = [...state.product.value!.reviews, review];
        final updatedProduct = state.product.value!.copyWith(
          reviews: updatedReviews,
        );

        // Update the state with the new product data
        state.setProduct(updatedProduct);

        _logger.d('Review added: ${review.toJson()}');
        Get.snackbar('Success', 'Review submitted successfully');
      } else {
        _logger.w('Review saved offline, will be synced later');
        Get.snackbar('Info', 'Review saved offline and will be synced later');

        // We can still update the UI optimistically
        final updatedReviews = [...state.product.value!.reviews, review];
        final updatedProduct = state.product.value!.copyWith(
          reviews: updatedReviews,
        );
        state.setProduct(updatedProduct);
      }
    } catch (e) {
      _logger.e('Error adding review: $e');
      Get.snackbar('Error', 'Failed to submit review');
    }
  }
  Future<void> addToCart() async {
    if (state.product.value == null) return;

    try {
      final product = state.product.value!;
      final quantity = state.quantity.value;

      // Make sure we're passing the correct variant ID
      // If no size is selected but there are sizes available, don't add to cart
      if (product.variants.containsKey('size') && 
          product.variants['size']!.isNotEmpty && 
          state.selectedSize.value.isEmpty) {
        Get.snackbar(
          'Warning',
          'Please select a size before adding to cart',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final cartController = Get.find<CartController>();

      // Using optimistic update approach
      await cartController.addToCart(
        product: product,
        quantity: quantity,
        variantId: state.selectedSize.value,
      );

      // Show a minimal snackbar to confirm the action
      Get.snackbar(
        'Success',
        'Item added to cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
    } catch (e) {
      // Silent error handling, UI will remain consistent
      _logger.e('Error adding to cart: $e');
    }
      // Silent error handling, UI will remain consistent
      _logger.e('Error adding to cart: $e');
    }
  }

