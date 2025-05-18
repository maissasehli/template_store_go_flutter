import 'package:get/get.dart';
import 'package:store_go/features/promotion/models/promotion_model.dart';

class ProductDetailState {
  // Product details state
  final Rx<dynamic> product = Rx<dynamic>(null);
  final RxBool isLoading = RxBool(false);
  final RxBool hasError = RxBool(false);
  final RxString errorMessage = RxString('');

  
  // Selected options
  final RxString selectedSize = RxString('');
  final RxString selectedColor = RxString('');
  final RxInt quantity = RxInt(1);
  final RxInt currentImageIndex = RxInt(0);
  
  // Promotions state
  final RxList<Promotion> promotions = RxList<Promotion>([]);
  final RxBool isLoadingPromotions = RxBool(false);
  
  // Product setters
  void setProduct(dynamic value) {
    product.value = value;
  }
  
  void clearProduct() {
    product.value = null;
  }
  
  // Loading state setters
  void setLoading(bool value) {
    isLoading.value = value;
  }
  
  // Error state setters
  void setError(String message) {
    errorMessage.value = message;
    hasError.value = true;
  }
  
  void clearError() {
    errorMessage.value = '';
    hasError.value = false;
  }
  
  // Option setters
  void setSelectedSize(String value) {
    selectedSize.value = value;
  }
  
  void setSelectedColor(String value) {
    selectedColor.value = value;
  }
  
  void setQuantity(int value) {
    quantity.value = value;
  }
  
  void setCurrentImageIndex(int value) {
    currentImageIndex.value = value;
  }
  
  // Promotions setters
  void setPromotions(List<Promotion> value) {
    promotions.value = value;
  }
  
  void setLoadingPromotions(bool value) {
    isLoadingPromotions.value = value;
  }
}