import 'package:get/get.dart';
import 'package:store_go/features/order/model/order_model.dart';
import 'package:store_go/features/order/repository/order_repository.dart';

class OrderController extends GetxController {
  final OrderRepository _repository;

  // Observable state
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString selectedStatus = 'Processing'.obs;
  final RxBool hasOrders = false.obs;

  // For order details
  final Rx<OrderModel?> selectedOrder = Rx<OrderModel?>(null);
  final RxBool isLoadingDetails = false.obs;

  OrderController({required OrderRepository repository})
      : _repository = repository;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

Future<void> fetchOrders() async {
  try {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final items = await _repository.getOrders(status: selectedStatus.value);
      orders.value = items;
      hasOrders.value = items.isNotEmpty;
    } catch (e) {
      // Set empty orders but still mark as loaded (instead of error state)
      orders.value = [];
      hasOrders.value = false;
      
      // Optional: you can still set error message for logging
      print('Server error when loading orders: $e');
    }
  } catch (e) {
    hasError.value = true;
    errorMessage.value = 'Failed to load orders. Please try again later.';
  } finally {
    isLoading.value = false;
  }
}
  void changeOrderStatus(String status) {
    if (selectedStatus.value != status) {
      selectedStatus.value = status;
      fetchOrders();
    }
  }

  Future<void> fetchOrderDetails(String orderId) async {
    try {
      isLoadingDetails.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final orderDetails = await _repository.getOrderDetails(orderId);
      selectedOrder.value = orderDetails;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoadingDetails.value = false;
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      await _repository.cancelOrder(orderId);
      // Refresh the orders list after cancellation
      await fetchOrders();
      // If currently viewing order details, refresh them too
      if (selectedOrder.value != null && selectedOrder.value!.id == orderId) {
        await fetchOrderDetails(orderId);
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }
}