import 'package:get/get.dart';
import 'package:store_go/app/core/services/enhanced_image_cache.dart';
import 'package:store_go/app/core/services/pusher_service.dart';
import 'package:store_go/app/shared/controllers/navigation_controller.dart';
import 'package:store_go/features/auth/services/token_manager.dart';
import 'package:store_go/app/shared/controllers/theme_controller.dart';
import 'package:store_go/app/core/services/image_preloader_manager.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/app/core/services/theme_aware_snackbar_service.dart';
import 'package:store_go/features/profile/repositories/profile_repository.dart';
import 'package:store_go/features/auth/services/auth_service.dart';
import 'package:store_go/features/payment/services/payment_service.dart';
import 'package:store_go/features/payment/services/stripe_service.dart';
import 'package:store_go/features/payment/repositories/payment_repository.dart';
import 'package:store_go/features/order/repositories/order_repository.dart';
import 'package:store_go/features/cart/repositories/cart_repository.dart';

class ServiceLocator {
  static Future<void> registerDependencies() async {
    // Register services - these are truly app-wide
    Get.put<ApiClient>(ApiClient(), permanent: true);

    // Register repositories
    Get.put<ProfileRepository>(
      ProfileRepository(apiClient: Get.find<ApiClient>()),
      permanent: true,
    );
    Get.put<CartRepository>(CartRepository(), permanent: true);
    Get.put<OrderRepository>(
      OrderRepository(apiClient: Get.find<ApiClient>()),
      permanent: true,
    );

    // Register payment services
    Get.put<PaymentRepository>(
      PaymentRepository(apiClient: Get.find<ApiClient>()),
      permanent: true,
    );

    Get.put<StripeService>(StripeService(), permanent: true);

    Get.put<PaymentService>(
      PaymentService(
        paymentRepository: Get.find<PaymentRepository>(),
        stripeService: Get.find<StripeService>(),
      ),
      permanent: true,
    );

    Get.put(TokenManager(), permanent: true);
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<ThemeController>(ThemeController(), permanent: true);
    Get.put<NavigationController>(
      NavigationController(),
      permanent: true,
    ); //  register PusherService
    Get.put<PusherService>(PusherService(), permanent: true);

    // Register ThemeAwareSnackbarService
    Get.put<ThemeAwareSnackbarService>(
      ThemeAwareSnackbarService(),
      permanent: true,
    );

    // Initialize image services
    await Get.putAsync<EnhancedImageCache>(
      () => EnhancedImageCache().init(),
      permanent: true,
    );
    await Get.putAsync(() => ImagePreloaderManager().init(), permanent: true);
  }
}
