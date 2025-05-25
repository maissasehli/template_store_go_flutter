import 'package:get/get.dart';
import 'package:store_go/features/checkout/controllers/checkout_controller.dart';
import 'package:store_go/features/order/binding/order_binding.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure OrderBinding dependencies are registered first
    OrderBinding().dependencies();

    // Only register CheckoutController since OrderRepository is already registered in OrderBinding
    Get.lazyPut<CheckoutController>(() => CheckoutController());
  }
}
