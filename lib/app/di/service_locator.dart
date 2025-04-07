import 'package:get/get.dart';
import 'package:store_go/app/core/services/enhanced_image_cache.dart';
import 'package:store_go/app/shared/controllers/navigation_controller.dart';
import 'package:store_go/features/auth/services/token_manager.dart';
import 'package:store_go/features/category/services/category_api_service.dart';
import 'package:store_go/app/shared/controllers/theme_controller.dart';
import 'package:store_go/app/core/services/image_preloader_manager.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/profile/services/user_api_service.dart';
import 'package:store_go/features/auth/services/auth_service.dart';

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
    Get.put(TokenManager(), permanent: true);
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<ThemeController>(ThemeController(), permanent: true);
    Get.put<NavigationController>(NavigationController(), permanent: true);

    // Initialize image services
    await Get.putAsync<EnhancedImageCache>(() => EnhancedImageCache().init(), permanent: true,);
    await Get.putAsync(() => ImagePreloaderManager().init(), permanent: true);
  }
}
