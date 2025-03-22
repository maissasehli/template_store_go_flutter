import 'package:get/get.dart';
import 'package:store_go/app/shared/controllers/navigation_controller.dart';
import 'package:store_go/app/shared/controllers/theme_controller.dart';
import 'package:store_go/features/language/controllers/language_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Global controllers only
    Get.put(ThemeController(), permanent: true);
    Get.put(NavigationController(), permanent: true);
    Get.put(LanguageController(), permanent: true);
  }
}
