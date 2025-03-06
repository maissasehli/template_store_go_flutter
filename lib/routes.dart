import 'package:get/get.dart';
import 'package:store_go/bindings/auth_binding.dart';
import 'package:store_go/core/constants/routes.dart';
import 'package:store_go/core/middleware/middleware.dart';
import 'package:store_go/view/screens/auth/emailsentconfirmation_resetpassword.dart';
import 'package:store_go/view/screens/auth/forgetpassword.dart';
import 'package:store_go/view/screens/auth/login.dart';
import 'package:store_go/view/screens/auth/resetpassword.dart';
import 'package:store_go/view/screens/auth/signup.dart';
import 'package:store_go/view/screens/home/home_screen.dart';
import 'package:store_go/view/screens/language/language.dart';
import 'package:store_go/view/screens/onboarding/onbordingScreen.dart';
import 'package:store_go/view/screens/onboarding/userprofilesetupscreen.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(name: "/", page: () => const Language(), middlewares: [
    Middleware()
  ]),
  
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
    binding: MyBinding(), 
  ),
GetPage(
    name: AppRoute.forgetpassword, 
    page: () =>  ForgetPassword(),
    binding: MyBinding(), 
  ),

GetPage(
  name: AppRoute.emailsentconfirmationresetpassword, 
  page: () => const EmailSentConfirmationResetPassword(), 
  binding: MyBinding(),
),
GetPage(
  name: AppRoute.resetPassword,
  page: () => ResetPasswordPage(),
    binding: MyBinding(),

),
  GetPage(
    name: AppRoute.home, 
    page: () =>  HomeScreen(),
    binding: MyBinding(), 
  ),

  
];