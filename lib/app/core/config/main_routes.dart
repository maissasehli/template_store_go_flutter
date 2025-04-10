import 'package:get/get.dart';
import 'package:store_go/app/core/middleware/auth_middleware.dart';
import 'package:store_go/features/auth/auth_binding.dart';
import 'package:store_go/features/home/home_binding.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:store_go/features/auth/views/email_confirmation_screen.dart';
import 'package:store_go/features/auth/views/forget_password_screen.dart';
import 'package:store_go/features/auth/views/login_screen.dart';
import 'package:store_go/features/auth/views/reset_password_screen.dart';
import 'package:store_go/features/auth/views/signup_screen.dart';
import 'package:store_go/features/cart/views/add_card_screen.dart';
import 'package:store_go/features/cart/views/cart_screen.dart';
import 'package:store_go/features/cart/views/chekout_screen.dart';
import 'package:store_go/features/category/views/category_screen.dart';
import 'package:store_go/features/home/views/home_screen.dart';
import 'package:store_go/features/language/language_binding.dart';
import 'package:store_go/features/language/views/language_screen.dart';
import 'package:store_go/features/onBoarding/views/onboarding_screen.dart';
import 'package:store_go/features/onBoarding/views/profile_setup_screen.dart';
import 'package:store_go/features/product/views/product_detail_screen.dart';
import 'package:store_go/features/product/views/products_screen.dart';
//import 'package:store_go/features/product/views/product_detail_screen.dart';
import 'package:store_go/features/profile/add_adress.dart';
import 'package:store_go/features/profile/adress_screen.dart';
import 'package:store_go/features/profile/edit_profile_screen.dart';
import 'package:store_go/features/profile/notification_screen.dart';
import 'package:store_go/features/orders/views/order_details/orders_detaill_screen.dart';
import 'package:store_go/features/orders/views/orders_screen.dart';
import 'package:store_go/features/profile/payment_screen.dart';
import 'package:store_go/features/profile/profile_screen.dart';
import 'package:store_go/app/shared/layouts/main_container_screen.dart';
import 'package:store_go/app/shared/screens/splash_screen.dart';
import 'package:store_go/features/wishlist/wishlist_screen.dart';

List<GetPage<dynamic>>? routes = [

  GetPage(name: '/', page: () => const SplashScreen(), middlewares: [AppMiddleware()]),

  GetPage(
    name: AppRoute.mainContainer,
    page: () => MainContainerScreen(),
    binding: HomeBinding(),
    middlewares: [AppMiddleware()]
  ),

  GetPage(
    name: AppRoute.language,
    page: () => const LanguageScreen(),
    binding: LanguageBinding(),
    middlewares: [AppMiddleware()]
    
  ),

  // OnBoarding
  GetPage(
    name: AppRoute.onBoarding, 
    page: () => Onboarding(),
    middlewares: [AppMiddleware()]),
  GetPage(
    name: AppRoute.profileSetup,
    page: () => const ProfileSetupScreen(),
    binding: AuthBinding(),
    
  ),

  // Auth
  GetPage(
    name: AppRoute.login,
     page: () => Login(),
   binding: AuthBinding(),
   middlewares: [AppMiddleware()],
),
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
    page: () => AddressPage(),
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
  GetPage(name: AppRoute.orders, page: () => OrdersPage()),
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
    GetPage(
    name: AppRoute.productscreen,
    page: () => ProductScreen(),
    binding: HomeBinding(),
  ),
  GetPage(
  name: AppRoute.productdetail,
  page: () => ProductDetail(),
  binding: HomeBinding(),
),
];
