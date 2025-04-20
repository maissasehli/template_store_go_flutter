import 'package:get/get.dart';
import 'package:store_go/features/product/models/product_model.dart';

/// State management class for product details
class ProductDetailState {
  // Observable states for product details
  final Rx<Product?> product = Rx<Product?>(null);
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // UI state for product details screen
  final RxInt currentImageIndex = 0.obs;
  final RxString selectedSize = RxString('');
  final RxString selectedColor = RxString('Black');
  final RxInt quantity = 1.obs;

  void setLoading(bool loading) {
    isLoading.value = loading;
  }

  void setError(String message) {
    hasError.value = true;
    errorMessage.value = message;
  }

  void clearError() {
    hasError.value = false;
    errorMessage.value = '';
  }

  void setProduct(Product newProduct) {
    product.value = newProduct;
  }

  void clearProduct() {
    product.value = null;
  }

  void setCurrentImageIndex(int index) {
    currentImageIndex.value = index;
  }

  void setSelectedSize(String size) {
    selectedSize.value = size;
  }

  void setSelectedColor(String color) {
    selectedColor.value = color;
  }

  void setQuantity(int value) {
    quantity.value = value;
  }
}
