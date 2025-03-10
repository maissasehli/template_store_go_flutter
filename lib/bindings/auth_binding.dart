import 'package:get/get.dart';
import 'package:store_go/controller/auth/forget_password.dart';
import 'package:store_go/controller/auth/login_controller.dart';
import 'package:store_go/controller/auth/reset_password.dart';
import 'package:store_go/controller/auth/signup_controller.dart';
import 'package:store_go/controller/onboarding/profile_setup.dart';
import 'package:store_go/core/services/auth_middleware.dart';
import 'package:store_go/core/services/auth_supabase.dart';

class MyBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());

    Get.lazyPut<SignupController>(() => SignupController());
    Get.lazyPut<ForgetPasswordController>(() => ForgetPasswordController());
    Get.lazyPut<ResetPasswordController>(() => ResetPasswordController());
    Get.lazyPut<ProfileSetupController>(() => ProfileSetupController());
    Get.lazyPut<ResetPasswordController>(() => ResetPasswordController());
    Get.lazyPut<AuthMiddlewareService>(
      () => AuthMiddlewareService(),
      fenix: true,
    );
    Get.lazyPut<AuthService>(() => AuthService(), fenix: true);
  }
}
