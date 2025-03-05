import 'package:get/get.dart';
import 'package:store_go/bindings/auth_binding.dart';
import 'package:store_go/core/constants/routes.dart';
import 'package:store_go/view/screens/auth/emailsentconfirmation.dart';
import 'package:store_go/view/screens/auth/forgetpassword.dart';
import 'package:store_go/view/screens/auth/login.dart';
import 'package:store_go/view/screens/auth/signup.dart';
import 'package:store_go/view/screens/home/home_screen.dart';
import 'package:store_go/view/screens/language/language.dart';
import 'package:store_go/view/screens/onboarding/onbordingScreen.dart';
import 'package:store_go/view/screens/onboarding/userprofilesetupscreen.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(name: "/", page: () => const Language(), middlewares: []),
  
  // OnBoarding
  GetPage(name: AppRoute.onBoarding, page: () => Onboarding()),
   GetPage(
    name: AppRoute.userprofilesetup, 
    page: () => const UserProfileSetupScreen(),
    binding: MyBinding(), 
  ),
  
  // Auth
  GetPage(
    name: AppRoute.login, 
    page: () =>  Login(),
    binding: MyBinding(), 
  ),
    GetPage(
    name: AppRoute.signup, 
    page: () => const Signup(),
    binding: MyBinding(), // Utilisez le nouveau binding ici
  ),
GetPage(
    name: AppRoute.forgetpassword, 
    page: () =>  ForgetPassword(),
    binding: MyBinding(), // Utilisez le nouveau binding ici
  ),
GetPage(
  name: AppRoute.emailsentconfirmation, 
  page: () => const EmailSentConfirmation(), // Note the 'const'
  binding: MyBinding(),
),
  GetPage(
    name: AppRoute.home, 
    page: () =>  HomeScreen(),
    binding: MyBinding(), // Utilisez le nouveau binding ici
  ),

  
];