import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/features/category/services/category_api_service.dart';
import 'package:store_go/features/home/controllers/home_controller.dart';
import 'package:store_go/features/product/controllers/product_detail_controller.dart';
import 'package:store_go/features/product/services/product_api_service.dart';
import 'package:store_go/features/wishlist/controllers/wishlist_controller.dart';
import 'package:store_go/features/wishlist/services/wishlist_api_service.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    // Create Dio instance if needed
    Get.lazyPut(() => Dio());
    
    // Create ProductApiService with the required argument
    Get.lazyPut(() => ProductApiService(Get.find()));
    
    // Create CategoryApiService
    Get.lazyPut(() => CategoryApiService(Get.find()));
    
    // Create WishlistApiService
    Get.lazyPut(() => WishlistApiService(Get.find()));
    
    // Create ProductController

    // Create CategoryController with API service
    Get.lazyPut<CategoryController>(() => CategoryControllerImp(Get.find<CategoryApiService>()));
    
    // Create HomeController
    Get.lazyPut(() => HomeController());
    
    
    // Create WishlistController with WishlistApiService
    Get.lazyPut(() => WishlistController(Get.find()), fenix: true);
        Get.lazyPut<ProductDetailControllerImp>(
      () => ProductDetailControllerImp(),
      fenix: true, // Permet au controller d'être réinitialisé à chaque appel
    );
  

  }
  
}

