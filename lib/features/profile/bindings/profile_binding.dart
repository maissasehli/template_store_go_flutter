import 'package:get/get.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/profile/controllers/profile_controller.dart';
import 'package:store_go/features/profile/repositories/profile_repository.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    // Check if ApiClient is already registered, if not register it
    if (!Get.isRegistered<ApiClient>()) {
      Get.put(ApiClient());
    }

    // Register ProfileRepository if not already registered
    if (!Get.isRegistered<ProfileRepository>()) {
      Get.put(ProfileRepository(apiClient: Get.find<ApiClient>()));
    }

    // Register ProfileController
    Get.lazyPut<ProfileController>(
      () => ProfileController(repository: Get.find<ProfileRepository>()),
    );
  }
}