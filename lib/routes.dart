import 'package:get/get.dart';
import 'package:store_go/bindings/auth_binding.dart';
import 'package:store_go/core/constants/routes.dart';
import 'package:store_go/core/middleware/middleware.dart';
import 'package:store_go/view/screens/auth/emailsentconfirmation.screen.dart';
import 'package:store_go/view/screens/auth/forgetpassword.screen.dart';
import 'package:store_go/view/screens/auth/login.screen.dart';
import 'package:store_go/view/screens/auth/resetpassword.screen.dart';
import 'package:store_go/view/screens/auth/signup.screen.dart';
import 'package:store_go/view/screens/home/home.screen.dart';
import 'package:store_go/view/screens/language/language.screen.dart';
import 'package:store_go/view/screens/onboarding/onbording.screen.dart';
import 'package:store_go/view/screens/onboarding/userprofilesetup.screen.dart';

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