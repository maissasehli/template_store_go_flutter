import 'package:get/get.dart';
import 'package:store_go/core/constants/routes.dart';


class EmailSentController extends GetxController {
  void returnToLogin() {
    Get.toNamed(AppRoute.login);
  }
}