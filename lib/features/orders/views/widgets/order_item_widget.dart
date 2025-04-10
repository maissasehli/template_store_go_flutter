import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/orders/controllers/order_controller.dart';
import 'package:store_go/features/orders/models/order_model.dart';

class OrderListView extends StatelessWidget {
  final StoreOrdersController controller;
  
  const OrderListView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.orders.length,
      itemBuilder: (context, index) {
        final order = controller.orders[index];
        return OrderItemWidget(order: order);
      },
    );
  }
}

class OrderItemWidget extends StatelessWidget {
  final OrderModel order;
  
  const OrderItemWidget({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            Icon(Icons.receipt_outlined, size: 24, color: Colors.grey[700]),
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
            const Icon(Icons.chevron_right, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
