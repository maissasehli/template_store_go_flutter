import 'package:get/get.dart';
import 'package:store_go/app/core/config/routes_config.dart';

class ResetPasswordController extends GetxController {
  void returnToLogin() {
    Get.offAllNamed(AppRoute.login);
  }
}
