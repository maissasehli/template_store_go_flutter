import 'package:get/get.dart';
import 'package:store_go/app/core/middlewares/auth_middleware.dart';
import 'package:store_go/features/address/view/edit_address_page.dart';
import 'package:store_go/features/auth/auth_binding.dart';
import 'package:store_go/features/category/category_binding.dart';
import 'package:store_go/features/home/home_binding.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:store_go/features/auth/views/email_confirmation_screen.dart';
import 'package:store_go/features/auth/views/forget_password_screen.dart';
import 'package:store_go/features/auth/views/login_screen.dart';
import 'package:store_go/features/auth/views/reset_password_screen.dart';
import 'package:store_go/features/auth/views/signup_screen.dart';
import 'package:store_go/features/cart/views/add_card_screen.dart';
import 'package:store_go/features/cart/views/cart_screen.dart';
import 'package:store_go/features/cart/views/checkout_screen.dart';
import 'package:store_go/features/category/views/category_screen.dart';
import 'package:store_go/features/home/views/home_screen.dart';
import 'package:store_go/features/language/language_binding.dart';
import 'package:store_go/features/language/views/language_screen.dart';
import 'package:store_go/features/onBoarding/views/onboarding_screen.dart';
import 'package:store_go/features/onBoarding/views/profile_setup_screen.dart';
import 'package:store_go/features/order/order_binding/order_binding.dart';
import 'package:store_go/features/product/product_binding.dart';
import 'package:store_go/features/product/views/screens/category_products_screen.dart';
import 'package:store_go/features/product/views/screens/filter/filter_screen.dart';
import 'package:store_go/features/product/views/screens/product_detail_screen.dart';
import 'package:store_go/features/profile/bindings/edit_profile_binding.dart';
import 'package:store_go/features/profile/bindings/profile_binding.dart';
import 'package:store_go/features/address/view/add_address.dart';
import 'package:store_go/features/address/view/address_screen.dart';
import 'package:store_go/features/profile/views/screens/edit_profile_screen.dart';
import 'package:store_go/features/notifications/views/notification_screen.dart';
import 'package:store_go/features/order/view/widget/orders_detaill_screen.dart';
import 'package:store_go/features/order/view/orders_screen.dart';
import 'package:store_go/features/payment/payment_screen.dart';
import 'package:store_go/features/profile/views/screens/profile_screen.dart';
import 'package:store_go/app/shared/layouts/main_container_screen.dart';
import 'package:store_go/app/shared/screens/splash_screen.dart';
import 'package:store_go/features/settings/views/setting_screen.dart';
import 'package:store_go/features/wishlist/views/wishlist_screen.dart';
import 'package:store_go/features/wishlist/wishlist_binding.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(name: '/', page: () => const SplashScreen()),

  // Protected routes with middleware
  GetPage(
    name: AppRoute.mainContainer,
    page: () => MainContainerScreen(),
    binding: HomeBinding(),
    middlewares: [AuthMiddleware()],
  ),

  GetPage(
    name: AppRoute.language,
    page: () => const LanguageScreen(),
    binding: LanguageBinding(),
  ),

  GetPage(
    name: AppRoute.settings,
    page: () => const SettingsScreen(),
    binding: HomeBinding(),
  ),

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
    bindings: [HomeBinding(), CategoryBinding()],
  ),

  // Categories
  GetPage(
    name: AppRoute.categories,
    page: () => CategoryScreen(),
    binding: CategoryBinding(),
  ),
 

  // Products
  GetPage(
    name: '/products/:id',
    page: () {
      final id = Get.parameters['id'] ?? '';
      return ProductDetailScreen(productId: id);
    },
    binding: ProductBinding(),
  ),
  GetPage(
    name: AppRoute.wishlist,
    page: () => WishlistPage(),
    binding: WishlistBinding(),
  ),
  GetPage(
    name: AppRoute.cart,
    page: () => CartScreen(),
    binding: HomeBinding(),
  ),
  GetPage(
    name: AppRoute.profile,
    page: () => const ProfilePage(),
    binding: ProfileBinding(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: AppRoute.edit_profile,
    page: () => EditProfilePage(),
    binding: EditProfileBinding(),
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
    name: AppRoute.edit_address,
    page: () => EditAddressPage(),
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
  GetPage(name: AppRoute.orders, page: () => OrdersPage(),binding: OrderBinding(),),
  GetPage(
    name: AppRoute.order_details,
    page: () => OrderDetailsPage(),
    binding: OrderBinding(),
  ),
  GetPage(
    name: AppRoute.notifications,
    page: () => NotificationsPage(),
    binding: HomeBinding(),
  ),
   GetPage(
    name: AppRoute.categoryDetail,
    page: () => CategoryProductsScreen(),
    transition: Transition.cupertino,
    binding: HomeBinding(),
  ),
   GetPage(
    name: AppRoute.filter,
    page: () => FilterPage(),
    binding: HomeBinding(),
  ),

];
