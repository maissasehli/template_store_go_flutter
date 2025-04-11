import 'package:get/get.dart';
import 'package:store_go/features/product/models/product_model.dart';
import 'package:store_go/features/product/services/product_api_service.dart';
import 'package:store_go/app/core/services/api_client.dart';

abstract class ProductDetailController extends GetxController {
  Future<void> loadProductDetails(String productId);
  void toggleFavorite();
  void addToCart();
  void selectImage(int index);
  void selectSize(String size);
  void selectColor(String color);
}

class ProductDetailControllerImp extends ProductDetailController {
  final isLoading = true.obs;
  final product = Rx<ProductModels?>(null);
  final selectedImageIndex = 0.obs;
  final quantity = 1.obs;

  // Add missing Rx variables for size and color
  final selectedSize = Rx<String>('M'); // Default to 'M'
  final selectedColor = Rx<String>('Black'); // Default to 'Black'

  final ProductApiService _productApiService = ProductApiService(ApiClient());

  @override
  void onInit() {
    super.onInit();

    // Get the product ID from arguments
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      if (args.containsKey('productId')) {
        final productId = args['productId'].toString();
        loadProductDetails(productId);
      }
    }
  }

  @override
  Future<void> loadProductDetails(String productId) async {
    try {
      isLoading(true);
      print("API request started for product ID: $productId");

      final response = await _productApiService
          .getProductById(productId)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw Exception("Request timed out"),
          );

      print("API response: ${response.statusCode} - ${response.data}");

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final productData = response.data['data'];

        // Parse the response data into a ProductModels object
        final productModel = ProductModels.fromJson(productData);

        // Update the observable product value
        product.value = productModel;

        // Set initial values based on the product data
        if (productModel.attributes != null) {
          if (productModel.attributes!.size != null &&
              productModel.attributes!.size!.isNotEmpty) {
            selectedSize.value = productModel.attributes!.size![0];
          }

          if (productModel.attributes!.color != null &&
              productModel.attributes!.color!.isNotEmpty) {
            selectedColor.value = productModel.attributes!.color![0];
          }
        }

      } else {
        throw Exception(
          "Failed to load product details. Status: ${response.statusCode}",
        );
      }
  
    } finally {
      isLoading(false);
    }
  }

  @override
  void toggleFavorite() {
    if (product.value != null && product.value!.id != null) {
      final currentStatus = product.value!.isFavorite ?? false;
      final newStatus = !currentStatus;

      // Update local state immediately for responsive UI
      final updatedProduct = product.value!.copyWith(isFavorite: newStatus);
      product.value = updatedProduct;

      // Send update to server
      _productApiService
          .toggleFavorite(product.value!.id!, newStatus)
          .then((_) {
            // Success already handled by UI update
          })
          .catchError((error) {
            // Revert on error
            product.value = product.value!.copyWith(isFavorite: currentStatus);

         
          });
    }
  }

  @override
  void addToCart() {
    // Implementation would connect to your cart service
    Get.snackbar(
      'Added to Cart',
      '${quantity.value} ${product.value?.name ?? 'item(s)'} added to cart',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void selectImage(int index) {
    selectedImageIndex.value = index;
  }

  // Implement the missing methods for size and color selection
  @override
  void selectSize(String size) {
    selectedSize.value = size;
  }

  @override
  void selectColor(String color) {
    selectedColor.value = color;
  }

  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  double getDiscountedPrice() {
    if (product.value == null) return 0.0;

    final originalPrice = double.tryParse(product.value!.price ?? '0.0') ?? 0.0;
    final discount = double.tryParse(product.value!.discount ?? '0.0') ?? 0.0;

    return discount > 0 ? originalPrice - discount : originalPrice;
  }

  double getOriginalPrice() {
    if (product.value == null) return 0.0;
    return double.tryParse(product.value!.price ?? '0.0') ?? 0.0;
  }

  bool hasDiscount() {
    final discount = double.tryParse(product.value?.discount ?? '0.0') ?? 0.0;
    return discount > 0;
  }

  // Modifiez la méthode getProductImages dans ProductDetailControllerImp
  List<String> getProductImages() {
    if (product.value == null || product.value!.imageUrls == null) {
      return [];
    }

    // Si l'imageUrls contient des virgules, divisez-le, sinon renvoyez-le comme une liste d'un seul élément
    final imageUrl = product.value!.imageUrls!;
    return imageUrl.contains(',') ? imageUrl.split(',') : [imageUrl];
  }

  // Add this method to ProductDetailControllerImp
  bool isProductInStock() {
    if (product.value == null) return false;
    return product.value!.inStock;
  }
}
