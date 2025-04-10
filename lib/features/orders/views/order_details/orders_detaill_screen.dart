import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/orders/views/widgets/order_details/order_items_widget.dart';
import 'package:store_go/features/orders/views/widgets/order_details/order_timeline_widget.dart';
import 'package:store_go/features/orders/views/widgets/order_details/shipping_details_widget.dart';
import '../../models/order_model.dart';


class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderModel order = Get.arguments;

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
        title: Text(
          'Order #${order.orderNumber}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OrderTimelineWidget(order: order),
              const SizedBox(height: 24),
              OrderItemsWidget(order: order),
              const SizedBox(height: 24),
              ShippingDetailsWidget(order: order),
            ],
          ),
        ),
      ),
    );
  }
}