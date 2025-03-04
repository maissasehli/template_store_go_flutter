import 'package:get/get.dart';
import 'package:store_go/controller/onboarding/auth/logincontroller.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    // Enregistrez les contrôleurs pour l'authentification
    Get.lazyPut<LoginController>(() => LoginController());
    
    // Décommentez si vous avez un contrôleur d'inscription
    // Get.lazyPut<SignupController>(() => SignupController());
  }
}