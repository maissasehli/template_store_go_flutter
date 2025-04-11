import 'package:dio/dio.dart' as dio;
import 'package:logger/logger.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/wishlist/model/wishlist_item_model.dart';

class WishlistApiService {
  final ApiClient _apiClient;
  final Logger _logger = Logger();

  WishlistApiService(this._apiClient);

  // Fetch user's wishlist
  Future<List<WishlistItem>> getWishlistItems() async {
    try {
      final response = await _apiClient.get('/wishlists');

      // Validate response
      if (response.statusCode != 200) {
        throw dio.DioException.badResponse(
          statusCode: response.statusCode ?? 404,
          requestOptions: response.requestOptions,
          response: response,
        );
      }

      // Parse response data
      final List<dynamic>? itemsData = response.data?['data'];
      if (itemsData != null) {
        return itemsData.map((json) => WishlistItem.fromJson(json)).toList();
      }
      return [];
    } on dio.DioException catch (e) {
      _logger.e('Detailed Wishlist Fetch Error');
      _logger.e('Status Code: ${e.response?.statusCode}');
      _logger.e('Error Message: ${e.message}');
      
      // If 404, we'll assume the endpoint is not ready yet and return empty list
      if (e.response?.statusCode == 404) {
        _logger.w('Wishlist endpoint returned 404. Returning empty list.');
        return [];
      }
      rethrow;
    } catch (e) {
      _logger.e('Unexpected error fetching wishlist: $e');
      rethrow;
    }
  }
  
  // Add item to wishlist
  Future<dio.Response> addToWishlist(WishlistItem item) async {
    try {
      final response = await _apiClient.post('/wishlists', data: item.toJson());
      return response;
    } catch (e) {
      _logger.e('Error adding to wishlist: $e');
      rethrow;
    }
  }

  // Remove item from wishlist
// Remove item from wishlist
Future<dio.Response> removeFromWishlist(String itemId) async {
  try {
    // Make sure the URL matches your server's API endpoint
    final response = await _apiClient.delete('wishlists/$itemId');
    _logger.i('Successfully removed item from wishlist: $itemId');
    return response;
  } on dio.DioException catch (e) {
    _logger.e('Error removing from wishlist: ${e.message}');
    _logger.e('Status code: ${e.response?.statusCode}');
    _logger.e('Response data: ${e.response?.data}');
    rethrow;
  } catch (e) {
    _logger.e('Unexpected error removing from wishlist: $e');
    rethrow;
  }
}
  // Update wishlist item quantity

Future<dio.Response> updateWishlistItemQuantity(String itemId, int quantity) async {
  try {
    // Utilisez Map<String, bool> avec des booléens uniquement
    Map<String, bool> boolData = {
      'isQuantityUpdate': true,
    };
    
    final response = await _apiClient.patch('/wishlists/$itemId?quantity=$quantity', data: boolData);
    
    return response;
  } catch (e) {
    _logger.e('Error updating wishlist item quantity: $e');
    rethrow;
  }
}

  // Toggle favorite status for a product
  Future<bool> toggleFavorite(String productId) async {
    try {
      _logger.i('Toggling favorite for product ID: $productId');
      
      // Utilisation de Map<String, dynamic> pour éviter les problèmes de typage
      Map<String, dynamic> requestData = {
        'product_id': productId,
      };
      
      final response = await _apiClient.post('/wishlists', data: requestData);
      
      // Check if response contains the favorite status
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Convert integer to boolean if needed
        final dynamic rawValue = response.data?['data']?['isFavorite'];
        final bool isFavorite = rawValue != null 
            ? (rawValue is bool ? rawValue : rawValue == 1) 
            : false;
        _logger.i('Product favorite status toggled: $isFavorite');
        return isFavorite;
      } else {
        _logger.w('Unexpected status code: ${response.statusCode}');
        return false;
      }
    } on dio.DioException catch (e) {
      _logger.e('Error toggling favorite: ${e.message}');
      _logger.e('Status code: ${e.response?.statusCode}');
      _logger.e('Response data: ${e.response?.data}');
      // For now, return false to indicate not favorited
      return false;
    } catch (e) {
      _logger.e('Unexpected error toggling favorite: $e');
      return false;
    }
  }
  
  // Check if a product is favorited
  Future<bool> checkFavoriteStatus(String productId) async {
    try {
      final response = await _apiClient.get('/wishlists/favorite/$productId');
      
      if (response.statusCode == 200) {
        // Convert integer to boolean if needed
        final dynamic rawValue = response.data?['data']?['isFavorite'];
        final bool isFavorite = rawValue != null 
            ? (rawValue is bool ? rawValue : rawValue == 1) 
            : false;
        return isFavorite;
      }
      return false;
    } catch (e) {
      _logger.e('Error checking favorite status: $e');
      return false;
    }
  }
}