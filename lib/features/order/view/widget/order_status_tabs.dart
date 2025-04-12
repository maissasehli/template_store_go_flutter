// File: lib/features/order/views/widgets/order_status_tabs.dart

import 'package:flutter/material.dart';
import 'package:store_go/features/order/controller/order_controller.dart';
import 'package:store_go/features/order/view/widget/status_tab.dart';

class OrderStatusTabs extends StatelessWidget {
  final OrderController controller;

  const OrderStatusTabs({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          StatusTab(
            status: 'Processing',
            isSelected: controller.selectedStatus.value == 'Processing',
            onTap: () {
              controller.changeOrderStatus('Processing');
            },
          ),
          StatusTab(
            status: 'Shipped',
            isSelected: controller.selectedStatus.value == 'Shipped',
            onTap: () {
              controller.changeOrderStatus('Shipped');
            },
          ),
          StatusTab(
            status: 'Delivered',
            isSelected: controller.selectedStatus.value == 'Delivered',
            onTap: () {
              controller.changeOrderStatus('Delivered');
            },
          ),
          StatusTab(
            status: 'Returns',
            isSelected: controller.selectedStatus.value == 'Returns',
            onTap: () {
              controller.changeOrderStatus('Returns');
            },
          ),
        ],
      ),
    );
  }
}