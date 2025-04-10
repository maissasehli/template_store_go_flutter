import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/orders/controllers/order_controller.dart';
import 'widgets/empty_state_widget.dart';
import 'widgets/order_item_widget.dart';
import 'widgets/status_tab_widget.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StoreOrdersController(), tag: 'store_orders');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Status Tabs
          Obx(() => controller.hasOrders.value
              ? OrderStatusTabsRow(controller: controller)
              : const SizedBox.shrink()),
          
          // Order List or Empty State
          Expanded(
            child: Obx(() => controller.hasOrders.value
                ? OrderListView(controller: controller)
                : const EmptyStateWidget()),
          ),
        ],
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