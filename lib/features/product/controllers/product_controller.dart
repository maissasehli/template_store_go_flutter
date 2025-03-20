import 'package:get/get.dart';
import 'package:store_go/features/home/models/color_variant_model.dart';
import 'package:store_go/features/home/models/product_model.dart';
import 'package:store_go/features/home/models/size_variant_model.dart';
import 'package:store_go/features/product/services/product_service.dart';

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
// Search products
Future<void> searchProducts(String query) async {
  searchQuery.value = query;
  isLoading(true);
  
  try {
    if (query.isEmpty) {
      await fetchProducts();
    } else {
      // Call the API for search or filter locally
      final allProducts = await _productService.getProducts();
      products.value = allProducts.where((product) => 
        product.name.toLowerCase().contains(query.toLowerCase()) ||
        product.description.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
  } catch (e) {
    Get.snackbar('Error', 'Failed to search products: $e');
  } finally {
    isLoading(false);
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

  // Filter products based on criteria
  void filterProducts({
    String? category,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    int? rating
  }) {
    isLoading(true);
    
    try {
      // Start with all products
      fetchProducts().then((_) {
        List<Product> filteredProducts = List.from(products);
        
        // Filter by search query if exists
        if (searchQuery.isNotEmpty) {
          filteredProducts = filteredProducts.where((product) => 
            product.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            product.description.toLowerCase().contains(searchQuery.toLowerCase())
          ).toList();
        }
        
        // Filter by category
        if (category != null && category != 'All') {
          filteredProducts = filteredProducts.where((product) => 
            product.category.toLowerCase() == category.toLowerCase()
          ).toList();
        }
        
        // Filter by price range
        if (minPrice != null && maxPrice != null) {
          filteredProducts = filteredProducts.where((product) => 
            product.price >= minPrice && product.price <= maxPrice
          ).toList();
        }
        
        // Filter by rating
        if (rating != null && rating > 0) {
          filteredProducts = filteredProducts.where((product) => 
            product.rating >= rating
          ).toList();
        }
        
        // Sort products
        if (sortBy != null) {
          switch (sortBy) {
            case 'New Today':
              // Since we don't have createdAt field, we'll just sort by id for demo
              filteredProducts.sort((a, b) => b.id.compareTo(a.id));
              break;
            case 'Top Sellers':
              // Since we don't have salesCount field, we'll sort by rating for demo
              filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
              break;
            case 'New collection':
              // Since we don't have isNewCollection field, we'll filter those with higher ids
              filteredProducts = filteredProducts.where((product) => 
                int.tryParse(product.id) != null && int.parse(product.id) > 5
              ).toList();
              break;
            default:
              break;
          }
        }
        
        // Update products list
        products.value = filteredProducts;
        isLoading(false);
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to filter products: $e');
      isLoading(false);
    }
  }

  // Get products that match the current search and filter criteria
  List<Product> getFilteredProducts() {
    return products;
  }

  // Clear all filters
  void clearFilters() {
    if (searchQuery.isNotEmpty) {
      // If there's a search query, just reapply the search
      searchProducts(searchQuery.value);
    } else {
      // Otherwise, get all products
      fetchProducts();
    }
  }
}