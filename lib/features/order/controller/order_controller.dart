import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/order/model/order_model.dart';
import 'package:store_go/features/order/repositories/order_repository.dart';

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

      final items = await _repository.getOrders(status: selectedStatus.value);
      orders.value = items;
      hasOrders.value = items.isNotEmpty;
    } catch (e) {
      // Handle error state
      orders.value = [];
      hasOrders.value = false;
      hasError.value = true;
      errorMessage.value = 'Failed to load orders. Please try again later.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchOrderDetails(String orderId) async {
    try {
      isLoadingDetails.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final orderDetails = await _repository.getOrderDetails(orderId);
      if (orderDetails != null) {
        selectedOrder.value = orderDetails;
      } else {
        hasError.value = true;
        errorMessage.value = 'Order details not available';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load order details. Please try again.';
    } finally {
      isLoadingDetails.value = false;
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      final success = await _repository.cancelOrder(orderId);
      if (success) {
        // Refresh the orders list after cancellation
        await fetchOrders();
        // If currently viewing order details, refresh them too
        if (selectedOrder.value != null && selectedOrder.value!.id == orderId) {
          await fetchOrderDetails(orderId);
        }
        Get.snackbar(
          'Success',
          'Order cancelled successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.7),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to cancel order',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.7),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to cancel order';
      Get.snackbar(
        'Error',
        'Failed to cancel order: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
    }
  }
  // Add this method to your OrderController class
void changeOrderStatus(String status) {
  if (selectedStatus.value != status) {
    selectedStatus.value = status;
    fetchOrders();
  }
}
}