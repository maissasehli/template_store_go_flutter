import 'package:get/get.dart';
import 'package:store_go/core/constants/routes.dart';

class EmailSentControllerResetPassword extends GetxController {
  void returnToLogin() {
    Get.offAllNamed(AppRoute.login); 
  }
}