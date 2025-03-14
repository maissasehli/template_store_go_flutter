import 'package:get/get.dart';
import 'package:store_go/core/model/home/color_variant_model.dart';
import 'package:store_go/core/model/home/product_model.dart';
import 'package:store_go/core/model/home/size_variant_model.dart';
import 'package:store_go/core/services/product_service.dart';

class ProductController extends GetxController {
  final ProductService _productService = ProductService();
  
  // Observable variables
  final RxList<Product> products = <Product>[].obs;
  final RxList<Product> featuredProducts = <Product>[].obs;
  final RxList<Product> newProducts = <Product>[].obs;
  final RxList<Product> favoriteProducts = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = ''.obs;
  final RxInt quantity = 1.obs;
  final RxList<ColorVariantModel> colorVariants = <ColorVariantModel>[].obs;
  final RxList<SizeVariantModel> sizeVariants = <SizeVariantModel>[].obs;
  
  // Get product by ID or load a specific product
  final Rx<Product?> selectedProduct = Rx<Product?>(null);
  
  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    fetchFeaturedProducts();
  }
  
  // Fetch all products
  Future<void> fetchProducts() async {
    isLoading(true);
    try {
      final result = await _productService.getProducts();
      products.value = result;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load products: $e');
    } finally {
      isLoading(false);
    }
  }
  
  // Fetch featured products
  Future<void> fetchFeaturedProducts() async {
    try {
      final result = await _productService.getFeaturedProducts();
      featuredProducts.value = result;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load featured products: $e');
    }
  }
  

  // Fetch products by category
  Future<void> fetchProductsByCategory(String categoryId) async {
    isLoading(true);
    selectedCategory.value = categoryId;
    try {
      final result = await _productService.getProductsByCategory(categoryId);
      products.value = result;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load products for this category: $e');
    } finally {
      isLoading(false);
    }
  }
  
  // Search products
  void searchProducts(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      fetchProducts();
    } else {
      products.value = products.where((product) => 
        product.name.toLowerCase().contains(query.toLowerCase()) ||
        product.description.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
  }
  
  // Toggle favorite status
  void toggleFavorite(String productId) {
    final index = products.indexWhere((product) => product.id == productId);
    if (index >= 0) {
      final product = products[index];
      final updatedProduct = product.copyWith(isFavorite: !product.isFavorite);
      products[index] = updatedProduct;
      
      // Update selected product if it's the same
      if (selectedProduct.value?.id == productId) {
        selectedProduct.value = updatedProduct;
      }
      
      // Update favorite products list
      if (updatedProduct.isFavorite) {
        favoriteProducts.add(updatedProduct);
      } else {
        favoriteProducts.removeWhere((p) => p.id == productId);
      }
      
      // Update in backend
      _productService.updateFavoriteStatus(productId, updatedProduct.isFavorite);
    }
  }
  
  // Fetch product details
  Future<void> fetchProductDetails(String productId) async {
    isLoading(true);
    try {
      final product = await _productService.getProductById(productId);
      selectedProduct.value = product;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load product details: $e');
    } finally {
      isLoading(false);
    }
  }
}