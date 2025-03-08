import 'package:get/get.dart';
import 'package:store_go/bindings/auth_binding.dart';
import 'package:store_go/core/constants/routes.dart';
import 'package:store_go/core/middleware/middleware.dart';
import 'package:store_go/view/screens/auth/email_confirmation.dart';
import 'package:store_go/view/screens/auth/forget_password.dart';
import 'package:store_go/view/screens/auth/login.dart';
import 'package:store_go/view/screens/auth/reset_password.dart';
import 'package:store_go/view/screens/auth/signup.dart';
import 'package:store_go/view/screens/home/home.dart';
import 'package:store_go/view/screens/language/language.dart';
import 'package:store_go/view/screens/onboarding/onboarding.dart';
import 'package:store_go/view/screens/onboarding/profile_setup.dart';

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
//HOME
  GetPage(
    name: AppRoute.home, 
    page: () =>  HomeScreen(),
    binding: MyBinding(), 
  ),

  
];