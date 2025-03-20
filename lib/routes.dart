import 'package:get/get.dart';
import 'package:store_go/bindings/auth_binding.dart';
import 'package:store_go/bindings/home_binding.dart';
import 'package:store_go/core/constants/routes_constants.dart';
import 'package:store_go/view/screens/auth/email_confirmation_screen.dart';
import 'package:store_go/view/screens/auth/forget_password_screen.dart';
import 'package:store_go/view/screens/auth/login_screen.dart';
import 'package:store_go/view/screens/auth/reset_password_screen.dart';
import 'package:store_go/view/screens/auth/signup_screen.dart';
import 'package:store_go/view/screens/cart/add_card.dart';
import 'package:store_go/view/screens/cart/cart_screen.dart';
import 'package:store_go/view/screens/cart/chekout_screen.dart';
import 'package:store_go/view/screens/category/category_screen.dart';
import 'package:store_go/view/screens/home/home_screen.dart';
import 'package:store_go/view/screens/language/language_screen.dart';
import 'package:store_go/view/screens/onboarding/onboarding_screen.dart';
import 'package:store_go/view/screens/onboarding/profile_setup_screen.dart';
import 'package:store_go/view/screens/product/product_detail_screen.dart';
import 'package:store_go/view/screens/profile/add_adress.dart';
import 'package:store_go/view/screens/profile/adress_screen.dart';
import 'package:store_go/view/screens/profile/edit_profile_screen.dart';
import 'package:store_go/view/screens/profile/notification_screen.dart';
import 'package:store_go/view/screens/profile/orders_detaill_screen.dart';
import 'package:store_go/view/screens/profile/orders_screen.dart';
import 'package:store_go/view/screens/profile/payment_screen.dart';
import 'package:store_go/view/screens/profile/profile_screen.dart';
import 'package:store_go/view/screens/shared/main_container_screen.dart';
import 'package:store_go/view/screens/shared/splash_screen.dart';
import 'package:store_go/view/screens/wishlist/wishlist_screen.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(name: '/', page: () => const SplashScreen()),

  GetPage(
    name: AppRoute.mainContainer,
    page: () => MainContainerScreen(),
    binding: HomeBinding(),
  ),
  
  GetPage(name: AppRoute.language, page: () => const Language()),
  
  // OnBoarding
  GetPage(name: AppRoute.onBoarding, page: () => Onboarding()),
  GetPage(
    name: AppRoute.profileSetup,
    page: () => const ProfileSetupScreen(),
    binding: AuthBinding(),
  ),
  
  // Auth
  GetPage(name: AppRoute.login, page: () => Login(), binding: AuthBinding()),
  GetPage(
    name: AppRoute.signup,
    page: () => const Signup(),
    binding: AuthBinding(),
  ),
  GetPage(
    name: AppRoute.forgetPassword,
    page: () => ForgetPassword(),
    binding: AuthBinding(),
  ),
  GetPage(
    name: AppRoute.emailResetPasswordConfirmation,
    page: () => const EmailSentConfirmationResetPassword(),
    binding: AuthBinding(),
  ),
  GetPage(
    name: AppRoute.resetPassword,
    page: () => ResetPasswordPage(),
    binding: AuthBinding(),
  ),
  
  // HOME
  GetPage(
    name: AppRoute.home, 
    page: () => HomeScreen(), 
    binding: HomeBinding(),
  ),
  
  // Categories
  GetPage(
    name: AppRoute.categories, 
    page: () => CategoryScreen(), 
    binding: HomeBinding(),
  ),
  GetPage(
    name: AppRoute.categoryDetail, 
    page: () {
      return CategoryScreen();
    }, 
    binding: HomeBinding(),
  ),
  
  // Products
  GetPage(
    name: AppRoute.productDetail, 
    page: () {
      final id = Get.parameters['id'] ?? '';
      return ProductDetailScreen(productId: id);
    }, 
    binding: HomeBinding(),
  ),
   GetPage(
    name: AppRoute.wishlist, 
    page: () => WishlistPage(), 
    binding: HomeBinding(),
  ),
   GetPage(
    name: AppRoute.cart, 
    page: () => CartScreen(), 
    binding: HomeBinding(),
  ),
   GetPage(
    name: AppRoute.profile, 
    page: () => ProfilePage(), 
    binding: HomeBinding(),
  ),
   GetPage(
    name: AppRoute.edit_profile, 
    page: () => EditProfilePage(), 
    binding: HomeBinding(),
  ),
  GetPage(
    name: AppRoute.checkout, 
    page: () => CheckoutScreen(), 
    binding: HomeBinding(),
  ),
   GetPage(
    name: AppRoute.address, 
    page: () => AddressPage (), 
    binding: HomeBinding(),
  ),
  GetPage(
    name: AppRoute.add_address, 
    page: () => AddAddressPage(), 
    binding: HomeBinding(),
  ),
   GetPage(
    name: AppRoute.payments, 
    page: () => PaymentPage(), 
    binding: HomeBinding(),
  ),
  GetPage(
    name: AppRoute.add_cart, 
    page: () => AddCardPage(), 
    binding: HomeBinding(),
  ),
   GetPage(
    name: AppRoute.orders, 
    page: () => OrdersPage(), 
    
  ),
   GetPage(
    name: AppRoute.order_details, 
    page: () => OrderDetailsPage(), 
    binding: HomeBinding(),
  ),
   GetPage(
    name: AppRoute.notifications, 
    page: () => NotificationsPage(), 
    binding: HomeBinding(),
  ),


  
  // Generic product list (if you need it)
 
];