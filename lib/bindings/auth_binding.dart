import 'package:get/get.dart';
import 'package:store_go/controller/auth/emailsentcontroller%20.dart';
import 'package:store_go/controller/auth/emailsentcontroller_resetpassword.dart';
import 'package:store_go/controller/auth/forgetpasswordcontroller.dart';
import 'package:store_go/controller/auth/logincontroller.dart';
import 'package:store_go/controller/auth/resetpasswordcontroller.dart';
import 'package:store_go/controller/auth/signupcontroller.dart';
import 'package:store_go/controller/onboarding/userprofilesetupcontroller.dart';

class MyBinding implements Bindings {
  @override
  void dependencies() {
    // Enregistrez les contrôleurs pour l'authentification
    Get.lazyPut<LoginController>(() => LoginController());

    
    Get.lazyPut<SignupController>(() => SignupController());
    Get.lazyPut<ForgetPasswordController>(() => ForgetPasswordController());
    Get.lazyPut<EmailSentController>(() => EmailSentController());
    Get.lazyPut<EmailSentController>(() => EmailSentController());
    Get.lazyPut<EmailSentControllerResetPassword>(() => EmailSentControllerResetPassword());
    Get.lazyPut<UserProfileSetupController>(() => UserProfileSetupController());
        Get.lazyPut<ResetPasswordController>(() => ResetPasswordController());




  }
}