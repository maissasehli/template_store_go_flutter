import 'package:get/get.dart';
import 'package:store_go/features/settings/controllers/settings_language_controller.dart';

class SettingsLanguageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SettingsLanguageController());
  }
}
