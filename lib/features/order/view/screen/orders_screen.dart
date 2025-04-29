import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/order/controller/order_controller.dart';
import 'package:store_go/features/order/view/widget/empty_order_state.dart';
import 'package:store_go/features/order/view/widget/error_view.dart';
import 'package:store_go/features/order/view/widget/order_list.dart';
import 'package:store_go/features/order/view/widget/order_status_tabs.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
            onPressed: () => Get.back(),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Orders',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchOrders(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Status Tabs
            Obx(
              () => controller.isLoading.value && controller.orders.isEmpty
                  ? const SizedBox.shrink()
                  : OrderStatusTabs(controller: controller),
            ),
            // Orders List, Loading Indicator, or Empty State
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.orders.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.hasError.value) {
                  return ErrorView(controller: controller);
                }

                if (!controller.hasOrders.value) {
                  return const EmptyOrderState();
                }

                return OrderList(controller: controller);
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
        ),
      ),
    );
  }
}