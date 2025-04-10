import 'package:dio/dio.dart' as dio;
import 'package:logger/logger.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/wishlist/model/wishlist_item_model.dart';

class WishlistApiService {
  final ApiClient _apiClient;
  final Logger _logger = Logger();

  WishlistApiService(this._apiClient);

  // Fetch user's wishlist
 Future<dio.Response> getWishlistItems() async {
    try {
      final response = await _apiClient.get('/wishlist');

      // Validate response
      if (response.statusCode != 200) {
        throw dio.DioException.badResponse(
          statusCode: response.statusCode ?? 404,
          requestOptions: response.requestOptions,
          response: response,
        );
      }

      return response;
    } on dio.DioException catch (e) {
      _logger.e('Detailed Wishlist Fetch Error');
      _logger.e('Status Code: ${e.response?.statusCode}');
      _logger.e('Error Message: ${e.message}');
      _logger.e('Response Data: ${e.response?.data}');
      rethrow;
    } catch (e) {
      _logger.e('Unexpected error fetching wishlist: $e');
      rethrow;
    }
  }
  // Add item to wishlist
  Future<dio.Response> addToWishlist(WishlistItem item) async {
    try {
      final response = await _apiClient.post('/wishlist', data: item.toJson());
      return response;
    } catch (e) {
      _logger.e('Error adding to wishlist: $e');
      rethrow;
    }
  }

  // Remove item from wishlist
  Future<dio.Response> removeFromWishlist(String itemId) async {
    try {
      final response = await _apiClient.delete('/wishlist/$itemId');
      return response;
    } catch (e) {
      _logger.e('Error removing from wishlist: $e');
      rethrow;
    }
  }

  // Update wishlist item quantity
  Future<dio.Response> updateWishlistItemQuantity(String itemId, int quantity) async {
    try {
      final response = await _apiClient.patch('/wishlist/$itemId', data: {
        'quantity': true,
        'isQuantityUpdate': true, // Add a boolean flag to indicate quantity update
      });
      return response;
    } catch (e) {
      _logger.e('Error updating wishlist item quantity: $e');
      rethrow;
    }
  }

  // Toggle wishlist item selection
  Future<dio.Response> toggleWishlistItemSelection(String itemId, bool isSelected) async {
    try {
      final response = await _apiClient.patch('/wishlist/$itemId', data: {
        'isSelected': isSelected 
      });
      return response;
    } catch (e) {
      _logger.e('Error toggling wishlist item selection: $e');
      rethrow;
    }
  }
}