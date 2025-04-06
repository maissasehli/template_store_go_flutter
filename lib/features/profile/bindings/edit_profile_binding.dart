import 'package:get/get.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/profile/controllers/edit_profile_controller.dart';
import 'package:store_go/features/profile/services/user_api_service.dart';

class EditProfileBinding implements Bindings {
  @override
  void dependencies() {
    // Check if ApiClient is already registered, if not register it
    if (!Get.isRegistered<ApiClient>()) {
      Get.put(ApiClient());
    }

    // Register UserApiService if not already registered
    if (!Get.isRegistered<UserApiService>()) {
      Get.put(UserApiService(Get.find<ApiClient>()));
    }

    // Register EditProfileController
    Get.put(EditProfileController(Get.find<UserApiService>()));
  }
}
