import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/product/services/product_api_service.dart';
import 'package:store_go/features/wishlist/model/wishlist_item_model.dart';
import 'package:store_go/features/wishlist/services/wishlist_api_service.dart';
import 'package:store_go/features/product/models/product_model.dart';

class WishlistController extends GetxController {
  final WishlistApiService _apiService;
  final Logger _logger = Logger();
  final ProductApiService _productApiService;

  // Observable state variables
  final RxList<WishlistItem> wishlistItems = <WishlistItem>[].obs;
  final RxList<ProductModels> products = <ProductModels>[].obs;
  final RxMap<String, ProductModels> productMap = <String, ProductModels>{}.obs;
  final RxBool isLoading = false.obs;
  final RxBool isFavoriteLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;

  WishlistController(this._apiService, this._productApiService);

  @override
  void onInit() {
    super.onInit();
    fetchWishlistItems();
  }

  // Get product details for a specific wishlist item
  ProductModels? getProductDetails(String wishlistItemId) {
    // Find the wishlist item
    final item = wishlistItems.firstWhere(
      (element) => element.id == wishlistItemId,
      orElse: () => WishlistItem(
        id: '', 
        name: 'Unknown', 
        description: '', 
        price: 0.0, 
        quantity: 1
      ),
    );
    
    // Return the product from our map
    return productMap[item.productId];
  }

  // Fetch wishlist items
  Future<void> fetchWishlistItems() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Step 1: Get wishlist items from API
      final List<WishlistItem> items = await _apiService.getWishlistItems();
      _logger.i('Fetched ${items.length} wishlist items from API');
      
      // Step 2: Get all product data for these wishlist items
      await _fetchProductDataForWishlist(items);
      
      // Update the wishlist items
      wishlistItems.value = items;
    } catch (e) {
      _handleError(e, 'Failed to load wishlist');
      _tryFallbackMethod();
    } finally {
      isLoading.value = false;
    }
  }
  
  // Fallback method to load from favorites if API fails
  Future<void> _tryFallbackMethod() async {
    try {
      _logger.i('Trying fallback method to load from favorites');
      
      // Get favorite products from product service
      final productResponse = await _productApiService.getAllProducts();
      final List<dynamic>? productsData = productResponse.data?['items'] ?? 
                                          productResponse.data?['data'];
      
      if (productsData != null) {
        // Parse products from API response
        final List<ProductModels> allProducts = productsData
            .map((json) => ProductModels.fromJson(json))
            .toList();
            
        // Filter to get only favorite products
        final favoriteProducts = allProducts
            .where((product) => product.isFavorite == true)
            .toList();
        
        // Create a map of all products for quick lookup
        productMap.clear();
        for (final product in allProducts) {
          if (product.id != null) {
            productMap[product.id!] = product;
          }
        }
        
        // Convert favorite products to wishlist items
        final List<WishlistItem> items = favoriteProducts.map((product) => WishlistItem(
          id: product.id ?? '',
          productId: product.id ?? '',
          name: product.name ?? 'Unknown Product',
          description: product.description ?? '',
          price: product.finalPrice,
          quantity: 1,
        )).toList();
        
        wishlistItems.value = items;
        _logger.i('Loaded ${items.length} wishlist items from products');
      }
    } catch (fallbackError) {
      _logger.e('Fallback method also failed: $fallbackError');
      wishlistItems.clear();
    }
  }
  
  // Fetch product data for wishlist items
 Future<void> _fetchProductDataForWishlist(List<WishlistItem> items) async {
  try {
    // Extract all product IDs from wishlist items
    final productIds = items.where((item) => item.productId != null && item.productId.isNotEmpty)
                            .map((item) => item.productId)
                            .toList();
    
    if (productIds.isEmpty) {
      _logger.w('No valid product IDs found in wishlist items');
      return;
    }
    
    // Create a map for quick lookup
    productMap.clear();
    
    // Fetch each product individually
    for (final productId in productIds) {
      try {
        final response = await _productApiService.getProductById(productId);
        
        if (response.statusCode == 200 && response.data != null) {
          final productData = response.data['data'] ?? response.data;
          final product = ProductModels.fromJson(productData);
          
          if (product.id != null) {
            productMap[product.id!] = product;
          }
        }
      } catch (productError) {
        _logger.e('Error fetching product $productId: $productError');
        // Continue with other products even if one fails
      }
    }
    
    // Update products list
    products.value = productMap.values.toList();
    
    _logger.i('Fetched ${productMap.length} product details for wishlist');
  } catch (e) {
    _logger.e('Failed to fetch product details: $e');
    // We'll continue anyway, but some product details might be missing
  }
}
  // Add item to wishlist
  Future<void> addToWishlist(WishlistItem item) async {
    try {
      isLoading.value = true;
      await _apiService.addToWishlist(item);
      await fetchWishlistItems();
    } catch (e) {
      _handleError(e, 'Failed to add item to wishlist');
    } finally {
      isLoading.value = false;
    }
  }

  // Remove item from wishlist
  Future<void> removeFromWishlist(String itemId) async {
    try {
      isLoading.value = true;
      await _apiService.removeFromWishlist(itemId);
      await fetchWishlistItems();
    } catch (e) {
      _handleError(e, 'Failed to remove item from wishlist');
    } finally {
      isLoading.value = false;
    }
  }

  // Update item quantity
  Future<void> updateItemQuantity(String itemId, int quantity) async {
    try {
      isLoading.value = true;
      await _apiService.updateWishlistItemQuantity(itemId, quantity);
      await fetchWishlistItems();
    } catch (e) {
      _handleError(e, 'Failed to update item quantity');
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle favorite status for a product
  Future<void> toggleFavorite(String productId) async {
    try {
      isFavoriteLoading.value = true;
      final bool isFavorite = await _apiService.toggleFavorite(productId);
      _logger.i('Product $productId favorite status: $isFavorite');
      
      // Refresh the wishlist to reflect changes
      await fetchWishlistItems();
      
      // Notify user of the action
      Get.snackbar(
        'Wishlist',
        isFavorite ? 'Added to wishlist' : 'Removed from wishlist',
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      _handleError(e, 'Failed to toggle favorite status');
    } finally {
      isFavoriteLoading.value = false;
    }
  }

  // Search wishlist items
  void searchWishlistItems(String query) {
    searchQuery.value = query;

    if (query.isEmpty) {
      fetchWishlistItems();
      return;
    }

    final filteredItems = wishlistItems.where((item) {
      // Get the associated product for richer search
      final product = productMap[item.productId];
      
      // Search in item name/description
      final matchesItem = item.name.toLowerCase().contains(query.toLowerCase()) ||
                          item.description.toLowerCase().contains(query.toLowerCase());
      
      // Also search in product details if available
      final matchesProduct = product != null && (
                          (product.name?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
                          (product.description?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
                          (product.subtitle?.toLowerCase().contains(query.toLowerCase()) ?? false));
      
      return matchesItem || matchesProduct;
    }).toList();

    wishlistItems.value = filteredItems;
  }

  // Sync wishlist with favorited products
  Future<void> syncWithProductFavorites() async {
    try {
      isLoading.value = true;
      
      // Get all products
      final productResponse = await _productApiService.getAllProducts();
      final List<dynamic>? productsData = productResponse.data?['items'] ?? 
                                          productResponse.data?['data'];
      
      if (productsData != null) {
        // Get products marked as favorites
        final favoriteProducts = productsData
            .map((json) => ProductModels.fromJson(json))
            .where((product) => product.isFavorite == true)
            .toList();
        
        // For each favorite product, ensure it's in the wishlist
        for (final product in favoriteProducts) {
          if (product.id != null) {
            // Use toggleFavorite which handles both adding and removing
            await _apiService.toggleFavorite(product.id!);
          }
        }
        
        // Refresh the wishlist
        await fetchWishlistItems();
      }
    } catch (e) {
      _handleError(e, 'Failed to sync favorites');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Centralized error handling
  void _handleError(dynamic error, String context) {
    String errorDetail = error.toString();
    _logger.e('$context: $errorDetail');
    errorMessage.value = context;
  }
}