
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/wishlist/models/wishlist_item_model.dart';

class WishlistRepository {
  final ApiClient _apiClient;

  WishlistRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<WishlistItemModel>> getWishlistItems() async {
    try {
      final response = await _apiClient.get('/products/wishlist');

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((item) => WishlistItemModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load wishlist items');
      }
    } catch (e) {
      throw Exception('Failed to load wishlist items: $e');
    }
  }

  Future<void> addToWishlist(String productId) async {
    try {
      await _apiClient.post('/products/wishlist/$productId');
    } catch (e) {
      throw Exception('Failed to add item to wishlist: $e');
    }
  }

  Future<void> removeFromWishlist(String productId) async {
    try {
      await _apiClient.delete('/products/wishlist/$productId');
    } catch (e) {
      throw Exception('Failed to remove item from wishlist: $e');
    }
  }
}
