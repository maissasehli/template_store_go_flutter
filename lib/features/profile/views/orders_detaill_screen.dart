import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/profile/views/orders_screen.dart';

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
              // Order Timeline
              _buildOrderTimeline(order),
              const SizedBox(height: 24),

              // Order Items
              _buildOrderItems(order),
              const SizedBox(height: 24),

              // Shipping Details
              _buildShippingDetails(order),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderTimeline(OrderModel order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTimelineItem(
          'Delivered',
          order.date,
          isActive: true,
          isFirst: true,
        ),
        _buildTimelineItem('Shipped', order.date, isActive: true),
        _buildTimelineItem('Order Confirmed', order.date, isActive: true),
        _buildTimelineItem(
          'Order Placed',
          order.date,
          isActive: true,
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildTimelineItem(
    String status,
    String date, {
    bool isActive = false,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? Colors.black : Colors.grey[300],
                border: Border.all(
                  color: isActive ? Colors.black : Colors.grey[300]!,
                  width: 2,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isActive ? Colors.black : Colors.grey[300],
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                status,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: isActive ? Colors.black : Colors.grey[400],
                ),
              ),
              SizedBox(height: isLast ? 0 : 24),
            ],
          ),
        ),
        Text(
          date,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Poppins',
            color: isActive ? Colors.grey[600] : Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItems(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Items',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.receipt_outlined, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '${order.itemCount} items',
                    style: const TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  // Navigate to detailed items list
                },
                child: const Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShippingDetails(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Shipping details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            order.shippingAddress,
            style: const TextStyle(fontSize: 14, fontFamily: 'Poppins'),
          ),
          const SizedBox(height: 8),
          Text(
            order.phoneNumber,
            style: const TextStyle(fontSize: 14, fontFamily: 'Poppins'),
          ),
        ],
      ),
    );
  }
}
