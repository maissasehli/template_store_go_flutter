// File: lib/features/order/views/widgets/order_list.dart

import 'package:flutter/material.dart';
import 'package:store_go/features/order/controller/order_controller.dart';
import 'package:store_go/features/order/view/widget/order_item.dart';

class OrderList extends StatelessWidget {
  final OrderController controller;

  const OrderList({
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
        return OrderItem(order: order);
      },
    );
  }
}