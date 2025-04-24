import 'package:get/get.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/address/controller/address_controller.dart'; // Add this
import 'package:store_go/features/address/repository/address_repository.dart';
import 'package:store_go/features/cart/controllers/cart_controller.dart';
import 'package:store_go/features/cart/repositories/cart_repository.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/features/category/repositories/category_repository.dart';
import 'package:store_go/features/home/controllers/home_controller.dart';
import 'package:store_go/features/order/repositories/order_repository.dart';
import 'package:store_go/features/payment/controller/payment_controller.dart';
import 'package:store_go/features/payment/repositories/payment_repository.dart'; // Add this
import 'package:store_go/features/category_product/controller/category_product_controller.dart';
import 'package:store_go/features/product/controllers/product_controller.dart';
import 'package:store_go/features/product/repositories/product_repository.dart';
import 'package:store_go/features/profile/controllers/profile_controller.dart';
import 'package:store_go/features/profile/repositories/profile_repository.dart';
import 'package:store_go/features/review/repositories/review_repository.dart';
import 'package:store_go/features/wishlist/controllers/wishlist_controller.dart';
import 'package:store_go/features/wishlist/repositories/wishlist_repository.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    final apiClient = Get.find<ApiClient>();

    // Register ApiClient (if not already registered elsewhere)
    Get.put(apiClient, permanent: true); // Ensure ApiClient is available

Get.lazyPut(() => ReviewRepository(apiClient: Get.find<ApiClient>()));
    // Register repositories
    Get.lazyPut(() => ProductRepository(
          apiClient: Get.find<ApiClient>(),
          reviewRepository: Get.find<ReviewRepository>(),
        ));
    Get.put<CartRepository>(
      CartRepository(apiClient: apiClient),
      permanent: true,
    );
    Get.put<WishlistRepository>(
      WishlistRepository(apiClient: apiClient),
      permanent: true,
    );
    Get.put<CategoryRepository>(
      CategoryRepository(apiClient: apiClient),
      permanent: true,
    );
    Get.put<ProfileRepository>(
      ProfileRepository(apiClient: apiClient),
      permanent: true,
    );
    Get.put<PaymentRepository>(
      PaymentRepository(apiClient: apiClient), // Register PaymentRepository
      permanent: true,
    );
    Get.put<AddressRepository>(
      AddressRepository(apiClient: apiClient), // Register AddressRepository (if exists)
      permanent: true,
    );

    // Register services
  

    // Register controllers
    Get.lazyPut<ProductController>(
      () => ProductController(repository: Get.find<ProductRepository>()),
      fenix: true,
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
      fenix: true,
    );
    Get.lazyPut<CategoryController>(
      () => CategoryController(repository: Get.find<CategoryRepository>()),
      fenix: true,
    );
    Get.lazyPut<WishlistController>(
      () => WishlistController(repository: Get.find<WishlistRepository>()),
      fenix: true,
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(repository: Get.find<ProfileRepository>()),
      fenix: true,
    );
    Get.lazyPut<CategoryProductController>(
      () => CategoryProductController(repository: Get.find<ProductRepository>()),
      fenix: true,
    );
    Get.put<CartController>(
      CartController(repository: Get.find<CartRepository>()),
      permanent: true,
    );
    Get.put<PaymentController>(
      PaymentController(repository: Get.find<PaymentRepository>()), // Use PaymentRepository
      permanent: true,
    );
    Get.put<AddressController>(
      AddressController(addressRepository: Get.find<AddressRepository>()), // Register AddressController
      permanent: true,
    );
Get.lazyPut<OrderRepository>(
  () => OrderRepository(apiClient: apiClient),
  fenix: true,
);
  }
  
}