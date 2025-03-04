import 'package:get/get.dart';
import 'package:store_go/controller/onboarding/userprofilesetupcontroller.dart';

class UserProfileSetupBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserProfileSetupController>(() => UserProfileSetupController());
  }
}