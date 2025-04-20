import 'package:get/get.dart';
import 'package:store_go/features/product/models/product_model.dart';

/// State management class for product listings
class ProductListState {
  // Observable states for product listing
  final RxList<Product> products = <Product>[].obs;
  final RxList<Product> featuredProducts = <Product>[].obs;
  final RxList<Product> newProducts = <Product>[].obs;
  final RxList<Product> searchResults = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

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

  void setProducts(List<Product> productList) {
    products.assignAll(productList);
  }

  void setFeaturedProducts(List<Product> productList) {
    featuredProducts.assignAll(productList);
  }

  void setNewProducts(List<Product> productList) {
    newProducts.assignAll(productList);
  }

  void setSearchResults(List<Product> productList) {
    searchResults.assignAll(productList);
  }

  void clearSearchResults() {
    searchResults.clear();
  }
}
