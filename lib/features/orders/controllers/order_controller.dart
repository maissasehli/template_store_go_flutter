import 'package:get/get.dart';
import '../models/order_model.dart';

// Abstract base class for Store Orders controller functionality
abstract class BaseStoreOrdersController extends GetxController {
  // Define abstract methods that must be implemented
  void loadOrders();
  void toggleOrdersView();
  void setSelectedStatus(String status);
  List<String> get availableStatuses;
}

class StoreOrdersController extends BaseStoreOrdersController {
  RxBool hasOrders = true.obs;
  RxString selectedStatus = 'Processing'.obs;
  RxList<OrderModel> orders = <OrderModel>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }
  
  @override
  void loadOrders() {
    orders.clear();
    orders.addAll([
      OrderModel(
        id: '1',
        orderNumber: '456765',
        itemCount: 4,
        status: 'Processing',
        date: '28 May',
        shippingAddress: '2716 Ash Dr, San Jose, South Dakota 83475',
        phoneNumber: '121-224-7890',
      ),
      OrderModel(
        id: '2',
        orderNumber: '454569',
        itemCount: 2,
        status: 'Processing',
        date: '26 May',
        shippingAddress: '2716 Ash Dr, San Jose, South Dakota 83475',
        phoneNumber: '121-224-7890',
      ),
      OrderModel(
        id: '3',
        orderNumber: '454809',
        itemCount: 1,
        status: 'Processing',
        date: '25 May',
        shippingAddress: '2716 Ash Dr, San Jose, South Dakota 83475',
        phoneNumber: '121-224-7890',
      ),
    ]);
  }
  
  @override
  void toggleOrdersView() {
    hasOrders.value = !hasOrders.value;
  }
  
  @override
  void setSelectedStatus(String status) {
    selectedStatus.value = status;
  }
  
  @override
  List<String> get availableStatuses => ['Processing', 'Shipped', 'Delivered', 'Returns'];
}