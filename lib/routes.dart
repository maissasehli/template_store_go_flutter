import 'package:get/get.dart';
import 'package:store_go/bindings/auth_binding.dart';
import 'package:store_go/bindings/home_binding.dart';
import 'package:store_go/core/constants/routes_constants.dart';
import 'package:store_go/core/middleware/middleware.dart';
import 'package:store_go/view/screens/auth/email_confirmation_screen.dart';
import 'package:store_go/view/screens/auth/forget_password_screen.dart';
import 'package:store_go/view/screens/auth/login_screen.dart';
import 'package:store_go/view/screens/auth/reset_password_screen.dart';
import 'package:store_go/view/screens/auth/signup_screen.dart';
import 'package:store_go/view/screens/category/category_screen.dart';
import 'package:store_go/view/screens/home/home_screen.dart';
import 'package:store_go/view/screens/language/language_screen.dart';
import 'package:store_go/view/screens/onboarding/onboarding_screen.dart';
import 'package:store_go/view/screens/onboarding/profile_setup_screen.dart';
import 'package:store_go/view/screens/product/product_detail_screen.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(name: "/", page: () => const Language(), middlewares: [Middleware()]),
  
  // OnBoarding
  GetPage(name: AppRoute.onBoarding, page: () => Onboarding()),
  GetPage(
    name: AppRoute.profileSetup,
    page: () => const ProfileSetupScreen(),
    binding: MyBinding(),
  ),
  
  // Auth
  GetPage(name: AppRoute.login, page: () => Login(), binding: MyBinding()),
  GetPage(
    name: AppRoute.signup,
    page: () => const Signup(),
    binding: MyBinding(),
  ),
  GetPage(
    name: AppRoute.forgetPassword,
    page: () => ForgetPassword(),
    binding: MyBinding(),
  ),
  GetPage(
    name: AppRoute.emailResetPasswordConfirmation,
    page: () => const EmailSentConfirmationResetPassword(),
    binding: MyBinding(),
  ),
  GetPage(
    name: AppRoute.resetPassword,
    page: () => ResetPasswordPage(),
    binding: MyBinding(),
  ),
  
  // HOME
  GetPage(
    name: AppRoute.home, 
    page: () => HomeScreen(), 
    binding: HomeBindings(),
  ),
  
  // Categories
  GetPage(
    name: AppRoute.categories, 
    page: () => CategoryScreen(), 
    binding: HomeBindings(),
  ),
  GetPage(
    name: AppRoute.categoryDetail, 
    page: () {
      return CategoryScreen();
    }, 
    binding: HomeBindings(),
  ),
  
  // Products
  GetPage(
    name: AppRoute.productDetail, 
    page: () {
      final id = Get.parameters['id'] ?? '';
      return ProductDetailScreen(productId: id);
    }, 
    binding: HomeBindings(),
  ),


  
  // Generic product list (if you need it)
 
];