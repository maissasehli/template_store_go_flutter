import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/order/model/order_model.dart';
import 'package:store_go/features/order/repositories/order_repository.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';

class OrderController extends GetxController {
  final OrderRepository _repository;

  // Observable state
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString selectedStatus = 'All'.obs;
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
      errorMessage.value = 'orders.load_error'.translate();
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
        errorMessage.value = 'orders.order_not_found'.translate();
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'orders.load_details_error'.translate();
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

  void changeOrderStatus(String status) {
    if (selectedStatus.value.toLowerCase() != status.toLowerCase()) {
      // Capitalize first letter for consistent display
      selectedStatus.value =
          status.substring(0, 1).toUpperCase() +
          status.substring(1).toLowerCase();
      fetchOrders();
    }
  }
}
