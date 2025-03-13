import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:store_go/core/theme/theme_controller.dart';
import 'package:store_go/core/services/image_cache.dart';
import 'package:store_go/core/services/image_preloader_manager.dart';
import 'package:store_go/core/services/api_client.dart';
import 'package:store_go/core/services/api/user_api_service.dart';
import 'package:store_go/core/services/auth_service.dart';

class DependencyInjection {
  static Future<void> init() async {
    // Initialize GetStorage for persistent theme settings
    await GetStorage.init();

    // Register Theme Controller
    Get.put<ThemeController>(ThemeController(), permanent: true);

    // Register image-related services
    await Get.putAsync(() => ImageCacheService().init(), permanent: true);
    await Get.putAsync(() => ImagePreloaderManager().init(), permanent: true);

    // IMPORTANT: Register ApiClient first before services that depend on it
    Get.put<ApiClient>(ApiClient(), permanent: true);

    // Register services that depend on ApiClient
    Get.put<UserApiService>(
      UserApiService(Get.find<ApiClient>()),
      permanent: true,
    );

    // Register AuthService
    Get.put<AuthService>(AuthService(), permanent: true);

  }
}
