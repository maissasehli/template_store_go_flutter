import 'package:get/get.dart';
import 'package:store_go/core/constants/routes_constants.dart';

class ResetPasswordController extends GetxController {
  void returnToLogin() {
    Get.offAllNamed(AppRoute.login);
  }
}
