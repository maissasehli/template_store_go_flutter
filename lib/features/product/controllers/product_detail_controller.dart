
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/product/models/product_modal.dart';
import 'package:store_go/features/product/services/product_service.dart';

class ProductDetailController extends GetxController {
  final ProductService _productService = Get.find<ProductService>();

  // Observable states for product details
  final Rx<Product?> selectedProduct = Rx<Product?>(null);
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // UI state for product details screen
  final RxInt currentImageIndex = 0.obs;
  final RxString selectedSize = RxString('');
  final RxString selectedColor = RxString('Black');
  final RxInt quantity = 1.obs;

  // Fetch product details by ID
  Future<void> fetchProductDetails(String productId) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      selectedProduct.value = null; // Clear previous product

      final product = await _productService.getProductById(productId);
      Logger().i('Fetched product: ${product.toJson()}');
      selectedProduct.value = product;

      // Set default selections based on product data
      _initializeProductOptions();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      Logger().e('Error fetching product details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Initialize product options once product is loaded
  void _initializeProductOptions() {
    final product = selectedProduct.value;
    if (product == null) return;

    // Set default color if available in variants
    if (product.variants.containsKey('color') &&
        product.variants['color']!.isNotEmpty) {
      selectedColor.value = product.variants['color']![0];
    }

    // Set default size if available in variants
    if (product.variants.containsKey('size') &&
        product.variants['size']!.isNotEmpty) {
      selectedSize.value = product.variants['size']![0];
    }

    // Reset quantity and image index
    quantity.value = 1;
    currentImageIndex.value = 0;
  }

  // Update selected size
  void updateSize(String size) {
    selectedSize.value = size;
  }

  // Update selected color
  void updateColor(String color) {
    selectedColor.value = color;
  }

  // Update quantity
  void updateQuantity(int value) {
    // Ensure quantity is at least 1
    if (value < 1) value = 1;

    // Optionally limit by available stock
    final product = selectedProduct.value;
    if (product != null && value > product.stockQuantity) {
      value = product.stockQuantity;
    }

    quantity.value = value;
  }

  // Update current image index
  void updateImageIndex(int index) {
    if (selectedProduct.value == null) return;

    // Ensure index is within bounds
    final imageCount = selectedProduct.value!.images.length;
    if (index >= 0 && index < imageCount) {
      currentImageIndex.value = index;
    }
  }

  // Toggle favorite status for the current product
  Future<void> toggleFavorite() async {
    if (selectedProduct.value == null) return;

    final productId = selectedProduct.value!.id;
    final currentStatus = selectedProduct.value!.isFavorite;

    // Update UI optimistically
    selectedProduct.value = selectedProduct.value!.copyWith(
      isFavorite: !currentStatus,
    );

    try {
      // Send update to API
      final success = await _productService.updateFavoriteStatus(
        productId,
        !currentStatus,
      );

      // If API call failed, revert the changes
      if (!success) {
        selectedProduct.value = selectedProduct.value!.copyWith(
          isFavorite: currentStatus,
        );
      }
    } catch (e) {
      // If there was an error, revert the changes
      selectedProduct.value = selectedProduct.value!.copyWith(
        isFavorite: currentStatus,
      );
      Logger().e('Error updating favorite status: $e');
    }
  }

  // Add current product to cart with selected options
  Future<void> addToCart() async {
    if (selectedProduct.value == null) return;

    try {
      // ignore: unused_local_variable
      final productId = selectedProduct.value!.id;
      Map<String, String> variants = {};

      // Add selected variants to options
      if (selectedSize.value.isNotEmpty) {
        variants['size'] = selectedSize.value;
      }

      if (selectedColor.value.isNotEmpty) {
        variants['color'] = selectedColor.value;
      }

      // Here you would typically call a cart service
      // For now, just show success message
      Get.snackbar(
        'Success',
        'Added to cart',
        snackPosition: SnackPosition.BOTTOM,
      );

      // You could implement the cart service call here:
      // final success = await _cartService.addToCart(
      //   productId: productId,
      //   quantity: quantity.value,
      //   variants: variants,
      // );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add item to cart',
        snackPosition: SnackPosition.BOTTOM,
      );
      Logger().e('Error adding to cart: $e');
    }
  }
}
