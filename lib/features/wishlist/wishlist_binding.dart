import 'package:get/get.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/wishlist/controllers/wishlist_controller.dart';
import 'package:store_go/features/wishlist/repositories/wishlist_repository.dart';

class WishlistBinding extends Bindings {
  @override
  void dependencies() {
    // Get ApiClient instance that's already set up with auth interceptors
    final apiClient = Get.find<ApiClient>();

    // Register repository
    Get.lazyPut<WishlistRepository>(
      () => WishlistRepository(apiClient: apiClient),
      fenix: true, // Add this to keep the instance alive
    );

    // Register controller with fenix to keep it alive across navigation
    Get.lazyPut<WishlistController>(
      () => WishlistController(repository: Get.find<WishlistRepository>()),
      fenix: true, // This ensures the controller persists
    );
  }
}
