import 'package:get/get.dart';
import 'package:store_go/app/core/controllers/navigation_controller.dart';
import 'package:store_go/app/core/controllers/theme_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Global controllers only
    Get.put(ThemeController(), permanent: true);
    Get.put(NavigationController(), permanent: true);
  }
}
