import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:store_go/core/theme/theme_controller.dart';
import 'package:store_go/core/services/image_cache.dart';
import 'package:store_go/core/services/image_preloader_manager.dart';

class DependencyInjection {
  static Future<void> init() async {
    // Initialize GetStorage for persistent theme settings
    await GetStorage.init();

    // Register Theme Controller
    Get.put<ThemeController>(ThemeController(), permanent: true);

    // Register image-related services
    await Get.putAsync(() => ImageCacheService().init(), permanent: true);
    await Get.putAsync(() => ImagePreloaderManager().init(), permanent: true);

    // Add other dependencies as needed
  }
}
