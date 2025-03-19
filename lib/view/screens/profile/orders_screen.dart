import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/core/constants/assets.dart';

// Model for order data
class OrderModel {
  final String id;
  final String orderNumber;
  final int itemCount;
  final String status;
  final String date;
  final String shippingAddress;
  final String phoneNumber;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.itemCount,
    required this.status,
    required this.date,
    required this.shippingAddress,
    required this.phoneNumber,
  });
}

// Controller for managing orders state
class StoreOrdersController extends GetxController {
  RxBool hasOrders = true.obs;
  RxString selectedStatus = 'Processing'.obs;
  RxList<OrderModel> orders = <OrderModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Example orders
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

    // For testing empty state, uncomment this line
    // hasOrders.value = false;
  }

  void toggleOrdersView() {
    hasOrders.value = !hasOrders.value;
  }
}

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Controller to manage orders state with unique name to avoid conflicts
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
              ? _buildOrderStatusTabs(controller)
              : const SizedBox.shrink()),
          // Order List or Empty State
          Expanded(
            child: Obx(() {
              return controller.hasOrders.value
                  ? _buildOrdersList(controller)
                  : _buildEmptyState();
            }),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFE0E0E0), width: 1),
          ),
        ),
     
      ),
    );
  }

  Widget _buildOrderStatusTabs(StoreOrdersController controller) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildStatusTab('Processing', controller.selectedStatus.value == 'Processing', () {
            controller.selectedStatus.value = 'Processing';
          }),
          _buildStatusTab('Shipped', controller.selectedStatus.value == 'Shipped', () {
            controller.selectedStatus.value = 'Shipped';
          }),
          _buildStatusTab('Delivered', controller.selectedStatus.value == 'Delivered', () {
            controller.selectedStatus.value = 'Delivered';
          }),
          _buildStatusTab('Returns', controller.selectedStatus.value == 'Returns', () {
            controller.selectedStatus.value = 'Returns';
          }),
        ],
      ),
    );
  }

  Widget _buildStatusTab(String status, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Text(
          status,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          const Text(
            'No Orders yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.toNamed('/categories'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text(
              'Explore Categories',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(StoreOrdersController controller) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.orders.length,
      itemBuilder: (context, index) {
        final order = controller.orders[index];
        return _buildOrderItem(order);
      },
    );
  }

  Widget _buildOrderItem(OrderModel order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => Get.toNamed('/order-details', arguments: order),
        child: Row(
          children: [
            Icon(
              Icons.receipt_outlined,
              size: 24,
              color: Colors.grey[700],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order #${order.orderNumber}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    '${order.itemCount} items',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }


}