import 'package:get/get.dart';
import 'package:store_go/controller/auth/emailsentresetpassword.controller.dart';
import 'package:store_go/controller/auth/forgetpassword.controller.dart';
import 'package:store_go/controller/auth/login.controller.dart';
import 'package:store_go/controller/auth/resetpassword.controller.dart';
import 'package:store_go/controller/auth/signup.controller.dart';
import 'package:store_go/controller/onboarding/userprofilesetup.controller.dart';
import 'package:store_go/core/services/authmiddelware.service.dart';
import 'package:store_go/core/services/authsupabase.service.dart';

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