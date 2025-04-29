import 'package:get/get.dart';
import 'package:store_go/app/core/middlewares/auth_middleware.dart';
import 'package:store_go/features/address/view/edit_address_page.dart';
import 'package:store_go/features/auth/binding/auth_binding.dart';
import 'package:store_go/features/cart/binding/cart_binding.dart';
import 'package:store_go/features/category/binding/category_binding.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/features/category_product/binding/category_product_binding.dart';
import 'package:store_go/features/category_product/view/screen/category_products_screen.dart';
import 'package:store_go/features/home/binding/home_binding.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:store_go/features/auth/views/screen/email_confirmation_screen.dart';
import 'package:store_go/features/auth/views/screen/forget_password_screen.dart';
import 'package:store_go/features/auth/views/screen/login_screen.dart';
import 'package:store_go/features/auth/views/screen/reset_password_screen.dart';
import 'package:store_go/features/auth/views/screen/signup_screen.dart';
import 'package:store_go/features/payment/view/widget/add_card_screen.dart';
import 'package:store_go/features/cart/views/screen/cart_screen.dart';
import 'package:store_go/features/cart/views/screen/checkout_screen.dart';
import 'package:store_go/features/category/views/category_screen.dart';
import 'package:store_go/features/home/views/screen/home_screen.dart';
import 'package:store_go/features/language/language_binding.dart';
import 'package:store_go/features/language/views/language_screen.dart';
import 'package:store_go/features/onBoarding/views/onboarding_screen.dart';
import 'package:store_go/features/onBoarding/views/profile_setup_screen.dart';
import 'package:store_go/features/order/binding/order_binding.dart';
import 'package:store_go/features/product/binding/product_binding.dart';
import 'package:store_go/features/filter/controllers/product_filter_controller.dart';
import 'package:store_go/features/product/controllers/product_list_controller.dart';
import 'package:store_go/features/filter/view/screen/filter_product_sheet.dart';
import 'package:store_go/features/product/views/screens/product_detail_screen.dart';
import 'package:store_go/features/product/views/screens/product_list_screen.dart';
import 'package:store_go/features/profile/bindings/edit_profile_binding.dart';
import 'package:store_go/features/profile/bindings/profile_binding.dart';
import 'package:store_go/features/address/view/add_address.dart';
import 'package:store_go/features/address/view/address_screen.dart';
import 'package:store_go/features/profile/views/screens/edit_profile_screen.dart';
import 'package:store_go/features/notifications/views/notification_screen.dart';
import 'package:store_go/features/order/view/widget/orders_details_screen.dart';
import 'package:store_go/features/order/view/screen/orders_screen.dart';
import 'package:store_go/features/payment/view/screen/payment_screen.dart';
import 'package:store_go/features/profile/views/screens/profile_screen.dart';
import 'package:store_go/app/shared/layouts/main_container_screen.dart';
import 'package:store_go/app/shared/screens/splash_screen.dart';
import 'package:store_go/features/review/binding/review_binding.dart';
import 'package:store_go/features/settings/views/setting_screen.dart';
import 'package:store_go/features/subcategory/controllers/subcategory_controller.dart';
import 'package:store_go/features/wishlist/views/wishlist_screen.dart';
import 'package:store_go/features/wishlist/binding/wishlist_binding.dart';

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
    name: AppRoute.productDetail,
    page: () {
      final id = Get.parameters['id'] ?? '';
      return ProductDetailScreen(productId: id);
    },
    binding: ProductBinding(),
  ),

  // New Product List Route
  GetPage(
    name: AppRoute.products,
    page: () => ProductListScreen(),
    binding: ProductBinding(),
  ),

  // Reviews
  GetPage(
    name: AppRoute.reviews,
    page: () {
      final productId = Get.parameters['productId'] ?? '';
      return ProductDetailScreen(productId: productId); // Adjust if you have a ReviewScreen
    },
    bindings: [ProductBinding(), ReviewBinding()],
  ),

  GetPage(
    name: AppRoute.wishlist,
    page: () => WishlistPage(),
    binding: WishlistBinding(),
  ),
  GetPage(
    name: AppRoute.cart,
    page: () => CartScreen(),
    binding: CartBinding(),
  ),
  GetPage(
    name: AppRoute.profile,
    page: () => const ProfilePage(),
    binding: ProfileBinding(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: AppRoute.editProfile,
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
    name: AppRoute.addAddress,
    page: () => AddAddressPage(),
    binding: HomeBinding(),
  ),
  GetPage(
    name: AppRoute.editAddress,
    page: () => EditAddressPage(),
    binding: HomeBinding(),
  ),
  GetPage(
    name: AppRoute.payments,
    page: () => PaymentMethodPage(),
    binding: HomeBinding(),
  ),
  GetPage(
    name: AppRoute.addPayment,
    page: () => const AddCardPage(),
    binding: HomeBinding(),
  ),
  GetPage(
    name: AppRoute.orders,
    page: () => OrdersPage(),
    binding: OrderBinding(),
  ),
  GetPage(
    name: AppRoute.orderDetails,
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
  binding: CategoryProductsBinding() as Bindings,
),
GetPage(
  name: AppRoute.filter,
  page: () => FilterBottomSheet(
    listController: Get.find<ProductListController>(),
    filterController: Get.find<ProductFilterController>(),
    categoryController: Get.find<CategoryController>(),
    subcategoryController: Get.find<SubcategoryController>(),
  ),
  transition: Transition.cupertino,
  binding: CategoryProductsBinding() as Bindings,
),

];