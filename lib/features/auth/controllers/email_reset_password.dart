import 'package:get/get.dart';
import 'package:store_go/app/core/config/routes_constants.dart';

class ResetPasswordController extends GetxController {
  void returnToLogin() {
    Get.offAllNamed(AppRoute.login);
  }
}
