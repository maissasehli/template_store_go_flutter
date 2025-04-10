import 'package:flutter/material.dart';
import '../../../models/order_model.dart';

class OrderTimelineWidget extends StatelessWidget {
  final OrderModel order;
  
  const OrderTimelineWidget({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TimelineItem(
          status: 'Delivered',
          date: order.date,
          isActive: true,
          isFirst: true,
        ),
        TimelineItem(
          status: 'Shipped',
          date: order.date,
          isActive: true,
        ),
        TimelineItem(
          status: 'Order Confirmed',
          date: order.date,
          isActive: true,
        ),
        TimelineItem(
          status: 'Order Placed',
          date: order.date,
          isActive: true,
          isLast: true,
        ),
      ],
    );
  }
}

class TimelineItem extends StatelessWidget {
  final String status;
  final String date;
  final bool isActive;
  final bool isFirst;
  final bool isLast;
  
  const TimelineItem({
    Key? key,
    required this.status,
    required this.date,
    this.isActive = false,
    this.isFirst = false,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
