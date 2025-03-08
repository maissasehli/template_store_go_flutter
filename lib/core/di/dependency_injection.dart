import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:store_go/core/theme/theme_controller.dart';

class DependencyInjection {
  static Future<void> init() async {
    // Initialize GetStorage for persistent theme settings
    await GetStorage.init();

    // Register Theme Controller
    Get.put<ThemeController>(ThemeController(), permanent: true);

    // Add other dependencies as needed
  }
}
