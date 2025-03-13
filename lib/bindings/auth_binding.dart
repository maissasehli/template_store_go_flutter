import 'package:get/get.dart';
import 'package:store_go/controller/auth/forget_password.dart';
import 'package:store_go/controller/auth/login_controller.dart';
import 'package:store_go/controller/auth/reset_password.dart';
import 'package:store_go/controller/auth/signup_controller.dart';
import 'package:store_go/controller/onboarding/profile_setup_controller.dart';

class MyBinding implements Bindings {
  @override
  void dependencies() {
    // Register controllers
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<SignupController>(() => SignupController());
    Get.lazyPut<ForgetPasswordController>(() => ForgetPasswordController());
    Get.lazyPut<ResetPasswordController>(() => ResetPasswordController());
    Get.lazyPut<ProfileSetupController>(() => ProfileSetupController());

    // Note: We removed the registrations for services that are now handled
    // in DependencyInjection.init() to avoid duplicate registrations
  }
}
