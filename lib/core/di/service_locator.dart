import 'package:get/get.dart';
import 'package:store_go/controller/other/navigation_controller.dart';
import 'package:store_go/core/services/api/category_api_service.dart';
import 'package:store_go/core/theme/theme_controller.dart';
import 'package:store_go/core/services/image_cache.dart';
import 'package:store_go/core/services/image_preloader_manager.dart';
import 'package:store_go/core/services/api/api_client.dart';
import 'package:store_go/core/services/api/user_api_service.dart';
import 'package:store_go/core/services/auth_service.dart';

// lib/core/di/dependency_injection.dart
class ServiceLocator {
  static Future<void> registerDependencies() async {
    // Register services - these are truly app-wide
    Get.put<ApiClient>(ApiClient(), permanent: true);
    Get.put<UserApiService>(
      UserApiService(Get.find<ApiClient>()),
      permanent: true,
    );
    Get.put<CategoryApiService>(
      CategoryApiService(Get.find<ApiClient>()),
      permanent: true,
    );
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<ThemeController>(ThemeController(), permanent: true);
    Get.put<NavigationController>(NavigationController(), permanent: true);

    // Initialize image services
    await Get.putAsync(() => ImageCacheService().init(), permanent: true);
    await Get.putAsync(() => ImagePreloaderManager().init(), permanent: true);
  }
}
