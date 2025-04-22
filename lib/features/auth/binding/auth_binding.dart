import 'package:get/get.dart';
import 'package:store_go/features/auth/controllers/forget_password.dart';
import 'package:store_go/features/auth/controllers/login_controller.dart';
import 'package:store_go/features/auth/controllers/reset_password.dart';
import 'package:store_go/features/auth/controllers/signup_controller.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    // Controllers only needed when on auth screens, can be recreated if needed
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<SignupController>(() => SignupController(), fenix: true);
    Get.lazyPut<ForgetPasswordController>(
      () => ForgetPasswordController(),
      fenix: true,
    );

    Get.lazyPut<ResetPasswordController>(
      () => ResetPasswordController(),
      fenix: true,
    );
   
  }
}
