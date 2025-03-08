import 'package:get/get.dart';
import 'package:store_go/controller/auth/email_reset_password.dart';
import 'package:store_go/controller/auth/forget_password.dart';
import 'package:store_go/controller/auth/login_controller.dart';
import 'package:store_go/controller/auth/reset_password.dart';
import 'package:store_go/controller/auth/signup_controller.dart';
import 'package:store_go/controller/onboarding/profile_setup.dart';
import 'package:store_go/core/services/auth_middleware.service.dart';
import 'package:store_go/core/services/auth_supabase.service.dart';

class MyBinding implements Bindings {
  @override
  void dependencies() {
    // Enregistrez les contrôleurs pour l'authentification
    Get.lazyPut<LoginController>(() => LoginController());

    
    Get.lazyPut<SignupController>(() => SignupController());
    Get.lazyPut<ForgetPasswordController>(() => ForgetPasswordController());
    Get.lazyPut<EmailSentControllerResetPassword>(() => EmailSentControllerResetPassword());
    Get.lazyPut<UserProfileSetupController>(() => UserProfileSetupController());
    Get.lazyPut<ResetPasswordController>(() => ResetPasswordController());
    Get.lazyPut<AuthMiddlewareService>(() => AuthMiddlewareService(), fenix: true);
    Get.lazyPut<AuthService>(() => AuthService(), fenix: true);






  }
}